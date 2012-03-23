require 'net/http'
require 'builder'
require "open-uri"

module Imentore

  PleskException = Class.new(StandardError)

  class PleskPesponse
    def initialize(status = nil,code = nil, message = nil, plesk_id = nil)

    end
  end

  class Plesk

    attr_accessor :host, :user, :pass, :timeout, :rpc_version, :xml_response, :xml_target

    def initialize(host = "207.7.84.39", user = 'admin', pass = 'plaszx12qw', timeout = 5, rpc_version = "1.6.0.2")
      @host, @user, @pass, @timeout, @rpc_version = host, user, pass, timeout, rpc_version
    end

    def add_domain(domain_name = "test.com", ip_address = '207.7.85.39', owner_id = 1, template_id = 1)
      begin
        Timeout.timeout(timeout) { open(host) if host.include?('http')}
      rescue Errno::ECONNREFUSED => e
        raise Imentore::PleskError.new(e.message)
      rescue SocketError => e
        raise Imentore::PleskError.new(e.message)
      rescue Timeout::Error => e
        raise Imentore::PleskError.new(e.message)
      end
      @xml_response, @xml_target = add_domain_rpc(domain_name, ip_address, owner_id ,template_id)
      status = Hash.from_xml(@xml_response)['packet']['domain']['add']['result']['status']
      pleskresponse = PleskPesponse.new(status)
      if pleskresponse.status == "error"
        pleskresponse.message = Hash.from_xml(@xml_response)['packet']['domain']['add']['result']['errtext']
        pleskresponse.code =  Hash.from_xml(@xml_response)['packet']['domain']['add']['result']['errcode']
        if (Hash.from_xml(@xml_response)['packet']['system']).present? and (Hash.from_xml(@xml_response)['packet']['system']['errcode'] == "1005" or Hash.from_xml(@xml_response)['packet']['system']['errcode'] == "1001")
          pleskresponse.message = Hash.from_xml(@xml_response)['packet']['system']['errtext']
          pleskresponse.code =  Hash.from_xml(@xml_response)['packet']['system']['errcode']
        end
        if @xml_response.to_s.include?('errcode') and Hash.from_xml(@xml_response)['packet']['domain']['add']['result']['errcode'] === "1007"
          pleskresponse.message = Hash.from_xml(@xml_response)['packet']['domain']['add']['result']
          pleskresponse.code =  Hash.from_xml(@xml_response)['packet']['domain']['add']['result']
        end
      end
      pleskresponse.plesk_id = Hash.from_xml(@xml_response)['packet']['domain']['add']['result']['id']
      return pleskresponse
      rescue NoMethodError => e
        raise Imentore::PleskException.new(e.message)
    end

    def add_domain_rpc(domain_name, ip_address, owner_id ,template_id)
      begin
        path = "/enterprise/control/agent.php"
        xml = Builder::XmlMarkup.new
        xml.instruct!
        xml.packet(:version => rpc_version) {
          xml.domain {
            xml.add{
              xml.gen_setup{
                xml.name(domain_name)
                xml.tag!('owner-id', owner_id)
                xml.ip_address(ip_address)
              }
              xml.tag!('template-id', template_id)
            }
          }
        }
        http = Net::HTTP.new(@host, 8443)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        @headers = {
              'HTTP_AUTH_LOGIN' => user,
              'HTTP_AUTH_PASSWD' => pass,
              'Accept' => '*/*',
              'Content-Type' => 'text/xml',
            }
        res, data = http.post2(path, xml.target!, @headers)
        return res.body, xml.target!
      rescue SocketError
        raise Imentore::PleskException.new("Remote Protocol Comunnication Error")
      end
    end

    def del_domain(plesk_id)
      @status = nil
      @errcode = nil
      @errtext = nil
      @plesk_id = nil
      @xml_response, @xml_target = del_domain_rpc(plesk_id)
      @status = Hash.from_xml(@xml_response)['packet']['domain']['del']['result']['status']
      if @status == "error"
        @errtext = Hash.from_xml(@xml_response)['packet']['domain']['del']['result']['errtext']
        @errcode = Hash.from_xml(@xml_response)['packet']['domain']['del']['result']['errcode']
        raise Imentore::PleskError.new(Hash.from_xml(@xml_response)['packet']['domain']['del']['result']['errtext']) if @xml_response.to_s.include?('errcode') 
      end
      return self      
      rescue NoMethodError 
        raise Imentore::PleskError.new("Error in code")
    end

    def del_domain_rpc(plesk_id)
      begin
        path = "/enterprise/control/agent.php"
        xml = Builder::XmlMarkup.new
        xml.instruct!
        xml.packet(:version => rpc_version) {
          xml.domain {
            xml.del {
              xml.filter {
                xml.id(plesk_id)
              }
            }
          }
        }
        http = Net::HTTP.new(@host, 8443)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        @headers = {
              'HTTP_AUTH_LOGIN' => @user,
              'HTTP_AUTH_PASSWD' => @pass,
              'Accept' => '*/*',
              'Content-Type' => 'text/xml',
            }
        res, data = http.post2(path, xml.target!, @headers)
        return res.body, xml.target!  
      rescue 
        raise Imentore::PleskError.new("RPC Error")
      end
    end

    def add_mail_domain(plesk_id, mail_name, password)
      @status = nil
      @errcode = nil
      @errtext = nil
      @rpc_version = '1.4.2.0'
      @xml_response, @xml_target = add_mail_domain_rpc(plesk_id, mail_name, password)
      @plesk_id = Hash.from_xml(@xml_response)['packet']['mail']['create']['result']['mailname']['id']
      @status = Hash.from_xml(@xml_response)['packet']['mail']['create']['result']['status']
      if @status == "error"
        @errtext = Hash.from_xml(@xml_response)['packet']['mail']['create']['result']['errtext']
        @errcode = Hash.from_xml(@xml_response)['packet']['mail']['create']['result']['errcode']
        raise Imentore::PleskError.new(Hash.from_xml(@xml_response)['packet']['mail']['create']['result']['errtext']) if @xml_response.to_s.include?('errcode') 
      end
      return self      
      rescue NoMethodError 
        raise Imentore::PleskError.new("Error in code")
    end

    def add_mail_domain_rpc(plesk_id, mail_name, password)
      begin
        path = "/enterprise/control/agent.php"
        xml = Builder::XmlMarkup.new
        xml.instruct!
        xml.packet(:version => @rpc_version) {
          xml.mail {
            xml.create {
              xml.filter {
                xml.domain_id(plesk_id) 
                xml.mailname{
                  xml.name(mail_name)
                  xml.mailbox{
                    xml.enabled(true)
                  }
                  xml.password(password)
                }
              }
            }
          }
        }
        http = Net::HTTP.new(@host, 8443)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        @headers = {
              'HTTP_AUTH_LOGIN' => @user,
              'HTTP_AUTH_PASSWD' => @pass,
              'Accept' => '*/*',
              'Content-Type' => 'text/xml',
            }
        res, data = http.post2(path, xml.target!, @headers)
        return res.body, xml.target!
      rescue 
        raise Imentore::PleskError.new("RPC Error")
      end
    end

    def del_mail_domain(plesk_id, mail_name)
      @status = nil
      @errcode = nil
      @errtext = nil
      @plesk_id = nil
      @rpc_version = '1.4.2.0'
      @xml_response, @xml_target = del_mail_domain_rpc(plesk_id, mail_name)
      @status = Hash.from_xml(@xml_response)['packet']['mail']['remove']['result']['status']
      if @status == "error"
        @errtext = Hash.from_xml(@xml_response)['packet']['mail']['remove']['result']['errtext']
        @errcode = Hash.from_xml(@xml_response)['packet']['mail']['remove']['result']['errcode']
        raise Imentore::PleskError.new(Hash.from_xml(@xml_response)['packet']['mail']['remove']['result']['errtext']) if @xml_response.to_s.include?('errcode') 
      end
      return self      
      rescue NoMethodError 
        raise Imentore::PleskError.new("Error in code")
    end

    def del_mail_domain_rpc(plesk_id, mail_name)
      begin
        path = "/enterprise/control/agent.php"
        xml = Builder::XmlMarkup.new
        xml.instruct!
        xml.packet(:version => @rpc_version) {
          xml.mail {
            xml.remove {
              xml.filter {
                xml.domain_id(plesk_id) 
                xml.name(mail_name)
              }
            }
          }
        }
        http = Net::HTTP.new(@host, 8443)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        @headers = {
              'HTTP_AUTH_LOGIN' => @user,
              'HTTP_AUTH_PASSWD' => @pass,
              'Accept' => '*/*',
              'Content-Type' => 'text/xml',
            }
        res, data = http.post2(path, xml.target!, @headers)
        return res.body, xml.target!
      rescue 
        raise Imentore::PleskError.new("RPC Error")
      end
    end

    def self.enable_domain_mail(domain_id)
      host = "207.7.84.39"
      path = "/enterprise/control/agent.php"
      xml = Builder::XmlMarkup.new(:target => out_string = "<?xml version='1.0' encoding='UTF-8'?>\n", :indent =>2)
      xml.packet(:version => "1.4.2.0") {
        xml.mail{
          xml.enable{
            xml.domain_id(domain_id)
          }
        }
      }
      http = Net::HTTP.new(host, 8443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @headers = {
            'HTTP_AUTH_LOGIN' => 'admin',
            'HTTP_AUTH_PASSWD' => PASS,
            'Accept' => '*/*',
            'Content-Type' => 'text/xml',
          }
      res, data = http.post2(path, out_string, @headers)
      return res.body
    end



  end
end
