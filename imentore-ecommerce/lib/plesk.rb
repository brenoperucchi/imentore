require 'net/http'
require 'builder'
require "open-uri"
require "rexml/document"
# include REXML

module Imentore

  PleskException = Class.new(StandardError)

  class PleskResponse

    attr_accessor :status, :code, :message, :plesk_id

    def initialize(status = nil, code = nil, message = nil)
      @status, @code, @message = status, code, message
    end
  end

  class Plesk

    attr_accessor :host, :user, :pass, :timeout, :rpc_version, :xml_response, :xml_target

    def initialize(host = "207.7.84.39", user = 'admin', pass = 'plaszx12qw', timeout = 5, rpc_version = "1.6.0.2")
      @host, @user, @pass, @timeout, @rpc_version = host, user, pass, timeout, rpc_version
    end

    def add_domain(domain_name = "test.com", ip_address = '207.7.85.39', owner_id = 1, template_id = 1)
      # hash = {:domain=>{:add=>{:gen_setup=>{:name=>domain_name, 'owner-id'=> owner_id.to_s, :ip_address=>ip_address}, 'template-id'=>template_id.to_s}}}
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
      begin
        Timeout.timeout(timeout) { open(host) if host.include?('http')}
      rescue Errno::ECONNREFUSED => e
        raise Imentore::PleskException.new(e.message)
      rescue SocketError => e
        raise Imentore::PleskException.new(e.message)
      rescue Timeout::Error => e
        raise Imentore::PleskException.new(e.message)
      end
      pleskresponse = PleskResponse.new
      # @xml_response, @xml_target = add_domain_rpc(domain_name, ip_address, owner_id ,template_id)
      @xml_response, @xml_target = remote_rpc(xml, @rpc_version)
      pleskresponse.status = Hash.from_xml(@xml_response)['packet']['domain']['add']['result']['status']
      if pleskresponse.status == "error"
        pleskresponse.message = Hash.from_xml(@xml_response)['packet']['domain']['add']['result']['errtext']
        pleskresponse.code =  Hash.from_xml(@xml_response)['packet']['domain']['add']['result']['errcode']
        if (Hash.from_xml(@xml_response)['packet']['system']).present? and (Hash.from_xml(@xml_response)['packet']['system']['errcode'] == "1005" or Hash.from_xml(@xml_response)['packet']['system']['errcode'] == "1001")
          pleskresponse.message = Hash.from_xml(@xml_response)['packet']['system']['errtext']
          pleskresponse.code =  Hash.from_xml(@xml_response)['packet']['system']['errcode']
        end
        if Hash.from_xml(@xml_response)['packet']['domain']['add']['result']['errcode'] === "1007"
          pleskresponse.message = Hash.from_xml(@xml_response)['packet']['domain']['add']['result']['errtext']
          pleskresponse.code =  Hash.from_xml(@xml_response)['packet']['domain']['add']['result']['errcode']
          raise Imentore::PleskException.new(pleskresponse.message) if pleskresponse.code == "1007"
        end
      end
      pleskresponse.plesk_id = Hash.from_xml(@xml_response)['packet']['domain']['add']['result']['id']
      return pleskresponse
      rescue NoMethodError => e
        raise Imentore::PleskException.new(e.message)
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
      raise Imentore::PleskException.new("Remote Protocol Comunnication Error")
    end

    # def add_domain_rpc(domain_name, ip_address, owner_id ,template_id)
    #   begin
    #     path = "/enterprise/control/agent.php"
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
    #     http = Net::HTTP.new(@host, 8443)
    #     http.use_ssl = true
    #     http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    #     @headers = {
    #           'HTTP_AUTH_LOGIN' => user,
    #           'HTTP_AUTH_PASSWD' => pass,
    #           'Accept' => '*/*',
    #           'Content-Type' => 'text/xml',
    #         }
    #     res, data = http.post2(path, xml.target!, @headers)

    #     return res.body, xml.target!
    #   rescue SocketError
    #     raise Imentore::PleskException.new("Remote Protocol Comunnication Error")
    #   end
    # end

    def del_domain(plesk_id)
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
      @xml_response, @xml_target = remote_rpc(xml)
      pleskresponse = PleskResponse.new
      pleskresponse.status = Hash.from_xml(@xml_response)['packet']['domain']['del']['result']['status']
      if pleskresponse.status == "error"
        pleskresponse.message = Hash.from_xml(@xml_response)['packet']['domain']['del']['result']['errtext']
        pleskresponse.code = Hash.from_xml(@xml_response)['packet']['domain']['del']['result']['errcode']
        raise Imentore::PleskException.new(pleskresponse.message)
      end
      return pleskresponse      
      rescue NoMethodError => e
        raise Imentore::PleskException.new(e.message)
    end

    # def del_domain_rpc(plesk_id)
    #   begin
    #     path = "/enterprise/control/agent.php"
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
    #     http = Net::HTTP.new(@host, 8443)
    #     http.use_ssl = true
    #     http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    #     @headers = {
    #           'HTTP_AUTH_LOGIN' => @user,
    #           'HTTP_AUTH_PASSWD' => @pass,
    #           'Accept' => '*/*',
    #           'Content-Type' => 'text/xml',
    #         }
    #     res, data = http.post2(path, xml.target!, @headers)
    #     return res.body, xml.target!  
    #   rescue 
    #     raise Imentore::PleskException.new("RPC Error")
    #   end
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
      pleskresponse = PleskResponse.new
      pleskresponse.status = Hash.from_xml(@xml_response)['packet']['mail']['create']['result']['status']
      if pleskresponse.status == "error"
        pleskresponse.message = Hash.from_xml(@xml_response)['packet']['mail']['create']['result']['errtext']
        pleskresponse.code = Hash.from_xml(@xml_response)['packet']['mail']['create']['result']['errcode']
        raise Imentore::PleskException.new(pleskresponse.message)
      end
      pleskresponse.plesk_id = Hash.from_xml(@xml_response)['packet']['mail']['create']['result']['mailname']['id']
      return pleskresponse
      rescue NoMethodError 
        raise Imentore::PleskException.new("Error in code")
    end

    # def add_mail_domain_rpc(plesk_id, mail_name, password)
    #   begin
    #     path = "/enterprise/control/agent.php"
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
    #     http = Net::HTTP.new(@host, 8443)
    #     http.use_ssl = true
    #     http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    #     @headers = {
    #           'HTTP_AUTH_LOGIN' => @user,
    #           'HTTP_AUTH_PASSWD' => @pass,
    #           'Accept' => '*/*',
    #           'Content-Type' => 'text/xml',
    #         }
    #     res, data = http.post2(path, xml.target!, @headers)
    #     return res.body, xml.target!
    #   rescue 
    #     raise Imentore::PleskException.new("RPC Error")
    #   end
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
      pleskresponse = PleskResponse.new
      pleskresponse.status = Hash.from_xml(@xml_response)['packet']['mail']['remove']['result']['status']
      if pleskresponse.status == "error"
        pleskresponse.message = Hash.from_xml(@xml_response)['packet']['mail']['remove']['result']['errtext']
        pleskresponse.code = Hash.from_xml(@xml_response)['packet']['mail']['remove']['result']['errcode']
        raise Imentore::PleskException.new(pleskresponse.message)
      end
      return pleskresponse
      rescue NoMethodError => e 
        raise Imentore::PleskException.new(e.message)
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
      pleskresponse = PleskResponse.new
      pleskresponse.status = Hash.from_xml(@xml_response)['packet']['mail']['update']['set']['result']['status']
      if pleskresponse.status == "error"
        pleskresponse.message = Hash.from_xml(@xml_response)['packet']['mail']['update']['set']['result']['errtext']
        pleskresponse.code = Hash.from_xml(@xml_response)['packet']['mail']['update']['set']['result']['errcode']
        raise Imentore::PleskException.new(pleskresponse.message)
      end
      return pleskresponse
      rescue NoMethodError => e 
        raise Imentore::PleskException.new(e.message)
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
      pleskresponse = PleskResponse.new
      pleskresponse.status = Hash.from_xml(@xml_response)['packet']['mail']['enable']['result']['status']
      if pleskresponse.status == "error"
        pleskresponse.message = Hash.from_xml(@xml_response)['packet']['mail']['enable']['result']['errtext']
        pleskresponse.code = Hash.from_xml(@xml_response)['packet']['mail']['enable']['result']['errcode']
        raise Imentore::PleskException.new(pleskresponse.message)
      end
      return pleskresponse
      rescue NoMethodError => e 
        raise Imentore::PleskException.new(e.message)
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
      puts "xml=> #{xml.to_s}"
      @xml_response, @xml_target = remote_rpc(xml, '1.4.2.0')
      puts "xml_response => #{@xml_response}"
      pleskresponse = PleskResponse.new
      pleskresponse.status = Hash.from_xml(@xml_response)['packet']['mail']['disable']['result']['status']
      if pleskresponse.status == "error"
        pleskresponse.message = Hash.from_xml(@xml_response)['packet']['mail']['disable']['result']['errtext']
        pleskresponse.code = Hash.from_xml(@xml_response)['packet']['mail']['disable']['result']['errcode']
        raise Imentore::PleskException.new(pleskresponse.message)
      end
      return pleskresponse
      rescue NoMethodError => e 
        raise Imentore::PleskException.new(e.message)
    end

  end
end
