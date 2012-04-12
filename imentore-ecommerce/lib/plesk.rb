require 'net/http'
require 'builder'
require "open-uri"
require "rexml/document"

module Imentore

  PleskException = Class.new(StandardError)

  class PleskResponse

    attr_accessor :status, :code, :message, :plesk_id

    def initialize(status = nil, code = nil, message = nil)
      @status, @code, @message = status, code, message
    end

    def success?
      @status == "ok"
    end

    def self.build_from_xml(string)
      response = self.new
      xml = REXML::Document.new(string)
      response.status = xml.root.elements['//status'].text
      if response.status == "error"
        response.code = xml.root.elements['//errcode'].text
        response.message = xml.root.elements['//errtext'].text
      else
        response.plesk_id = xml.root.elements['//id'].text if xml.root.elements['//id'].present?
      end
      return response
    end

  end

  class Plesk
    attr_accessor :host, :user, :pass, :timeout, :rpc_version, :xml_response, :xml_target

    def initialize(host = "207.7.84.39", user = 'admin', pass = 'plaszx12qw', timeout = 5)
      @host, @user, @pass, @timeout = host, user, pass, timeout
    end

    def add_domain(domain_name = "test.com", ip_address = '207.7.85.39', owner_id = 1, template_id = 1)
string = <<EOF
<domain> 
  <add> 
    <gen_setup>
      <name>#{domain_name}</name>
      <owner-id>#{owner_id}</owner-id>
      <ip_address>#{ip_address}</ip_address>
    </gen_setup>
    <template-id>#{template_id}</template-id>
  </add>
</domain>
EOF
xml = REXML::Document.new(string)
      rpc_version = "1.6.0.2"
      begin
        Timeout.timeout(timeout) { open(host) if host.include?('http')}
      rescue Errno::ECONNREFUSED => e
        raise Imentore::PleskException.new(e.message)
      rescue SocketError => e
        raise Imentore::PleskException.new(e.message)
      rescue Timeout::Error => e
        raise Imentore::PleskException.new(e.message)
      end
      @xml_response, @xml_target = remote_rpc(xml, rpc_version)
      pleskresponse = PleskResponse.build_from_xml(@xml_response)
      return pleskresponse
    end

    def remote_rpc(xml2, rpc_version = @rpc_version)
      path = "/enterprise/control/agent.php"
string = <<EOF
<?xml version='1.0' encoding='UTF-8'?>
  <packet version='#{rpc_version}'>
    #{xml2.to_s}
  </packet>
EOF
doc = REXML::Document.new(string)
      http = Net::HTTP.new(@host, 8443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @headers = {
            'HTTP_AUTH_LOGIN' => @user,
            'HTTP_AUTH_PASSWD' => @pass,
            'Accept' => '*/*',
            'Content-Type' => 'text/xml',
          }
      res, data = http.post2(path, doc.to_s, @headers)
      return res.body, doc.to_s
    rescue SocketError
      raise Imentore::PleskException.new("Remote Protocol Comunnication Socket Error")
    end

    # def add_domain_rpc(domain_name, ip_address, owner_id ,template_id)
    #     xml = Builder::XmlMarkup.new
    #     xml.instruct!
    #     xml.packet(:version => rpc_version) {
    #       xml.domain {
    #         xml.add{
    #           xml.gen_setup{
    #             xml.name(domain_name)
    #             xml.tag!('owner-id', owner_id)
    #             xml.ip_address(ip_address)
    #           }
    #           xml.tag!('template-id', template_id)
    #         }
    #       }
    #     }
    # end

    def del_domain(plesk_id)
    rpc_version = "1.6.0.2"
string = <<EOF
<domain> 
  <del>
    <filter>
      <id>#{plesk_id}</id>
    </filter>
  </del>
</domain>
EOF
xml = REXML::Document.new(string)
      @xml_response, @xml_target = remote_rpc(xml, rpc_version)
      pleskresponse = PleskResponse.build_from_xml(@xml_response)
      return pleskresponse      
    end

    # def del_domain_rpc(plesk_id)
    #     xml = Builder::XmlMarkup.new
    #     xml.instruct!
    #     xml.packet(:version => rpc_version) {
    #       xml.domain {
    #         xml.del {
    #           xml.filter {
    #             xml.id(plesk_id)
    #           }
    #         }
    #       }
    #     }
    # end

    def add_mail_domain(plesk_id, mail_name, password)
string = <<EOF
<mail> 
  <create>
    <filter>
      <domain_id>#{plesk_id}</domain_id>
      <mailname>
        <name>#{mail_name}</name>
        <mailbox>
          <enabled>true</enabled>
        </mailbox>
        <password>#{password}</password>
      </mailname>
    </filter>
  </create>
</mail>
EOF
xml = REXML::Document.new(string)
      @xml_response, @xml_target = remote_rpc(xml, '1.4.2.0')
      pleskresponse = PleskResponse.build_from_xml(@xml_response)
      return pleskresponse
    end

    # def add_mail_domain_rpc(plesk_id, mail_name, password)
    #     xml = Builder::XmlMarkup.new
    #     xml.instruct!
    #     xml.packet(:version => @rpc_version) {
    #       xml.mail {
    #         xml.create {
    #           xml.filter {
    #             xml.domain_id(plesk_id) 
    #             xml.mailname{
    #               xml.name(mail_name)
    #               xml.mailbox{
    #                 xml.enabled(true)
    #               }
    #               xml.password(password)
    #             }
    #           }
    #         }
    #       }
    #     }
    # end

    def del_mail_domain(plesk_id, mail_name)
      @rpc_version = '1.4.2.0'
string = <<EOF
<mail> 
  <remove>
    <filter>
      <domain_id>#{plesk_id}</domain_id>
      <name>#{mail_name}</name>
    </filter>
  </remove>
</mail>
EOF
xml = REXML::Document.new(string)
      @xml_response, @xml_target = remote_rpc(xml, '1.4.2.0')
      pleskresponse = PleskResponse.build_from_xml(@xml_response)
      return pleskresponse
    end


    def change_mail_domain(plesk_id, mail_name, password)
      string = <<EOF
<mail> 
  <update>
    <set>
      <filter>
        <domain_id>#{plesk_id}</domain_id>
        <mailname>
          <name>#{mail_name}</name>
          <password>#{password}</password>
        </mailname>
      </filter>
    </set>
  </update>
</mail>
EOF
xml = REXML::Document.new(string)
      @xml_response, @xml_target = remote_rpc(xml, '1.4.2.0')
      pleskresponse = PleskResponse.build_from_xml(@xml_response)
      return pleskresponse
    end


    def enable_mail_domain(plesk_id)
string = <<EOF
<mail> 
  <enable>
    <domain_id>#{plesk_id}</domain_id>
  </enable>
</mail>
EOF
xml = REXML::Document.new(string)
      @xml_response, @xml_target = remote_rpc(xml, '1.4.2.0')
      pleskresponse = PleskResponse.build_from_xml(@xml_response)
      return pleskresponse
    end

    def disable_mail_domain(plesk_id)
string = <<EOF
<mail> 
  <disable>
    <domain_id>#{plesk_id}</domain_id>
  </disable>
</mail>
EOF
xml = REXML::Document.new(string)
      @xml_response, @xml_target = remote_rpc(xml, '1.4.2.0')
      pleskresponse = PleskResponse.build_from_xml(@xml_response)
      return pleskresponse
    end

  end
end
