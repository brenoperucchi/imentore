require 'net/http'
require 'builder'
require "open-uri"

module Imentore
  PASS = 'plaszx12qw'

  PleskError = Class.new(StandardError)

  class Plesk

    attr_accessor :host, :user, :pass, :timeout, :rpc_version, :plesk_id, :status

    def initialize(host = "207.7.84.39", user = 'admin', pass = 'plaszx12qw', timeout = 5, rpc_version = "1.6.0.2")
      @host, @user, @pass, @timeout, @rpc_version = host, user, pass, timeout, rpc_version
    end

    def add_domain(domain_name = "test.com")
      begin
        Timeout.timeout(timeout) { open(host) if host.include?('http')}
      rescue Errno::ECONNREFUSED => e
        raise Imentore::PleskError.new(e.message)
      rescue SocketError => e
        raise Imentore::PleskError.new(e.message)
      rescue Timeout::Error => e
        raise Imentore::PleskError.new(e.message)
      end
      xml = add_domain_rpc(domain_name)
      raise Imentore::PleskError.new(Hash.from_xml(xml)['packet']['system']['status']) if  (Hash.from_xml(xml)['packet']['system']).present? and Hash.from_xml(xml)['packet']['system']['errcode'] === "1005"
      raise Imentore::PleskError.new(Hash.from_xml(xml)['packet']['system']['status']) if  (Hash.from_xml(xml)['packet']['system']).present? and Hash.from_xml(xml)['packet']['system']['errcode'] === "1001"
      raise Imentore::PleskError.new(Hash.from_xml(xml)['packet']['domain']['add']['result']['status']) if xml.to_s.include?('errcode') and Hash.from_xml(xml)['packet']['domain']['add']['result']['errcode'] === "1007"
      @plesk_id = Hash.from_xml(xml)['packet']['domain']['add']['result']['id']
      @status = Hash.from_xml(xml)['packet']['domain']['add']['result']['status']
      return self
    end

    def del_domain(plesk_id)
      xml = del_domain_rpc(plesk_id)
      @status = Hash.from_xml(xml)['packet']['domain']['del']['result']['status']
      return self
    end

    def add_domain_rpc(domain_name)
      host = "207.7.84.39"
      path = "/enterprise/control/agent.php"
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.packet(:version => rpc_version) {
        xml.domain {
          xml.add{
            xml.gen_setup{
              xml.name(domain_name)
              xml.tag!('owner-id', 1)
              xml.ip_address('207.7.85.39')
            }
            xml.tag!('template-id', 1)
          }
        }
      }
      http = Net::HTTP.new(host, 8443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @headers = {
            'HTTP_AUTH_LOGIN' => user,
            'HTTP_AUTH_PASSWD' => pass,
            'Accept' => '*/*',
            'Content-Type' => 'text/xml',
          }
      res, data = http.post2(path, xml.target!, @headers)
      return res.body
    end

    def del_domain_rpc(plesk_id)
      host = "207.7.84.39"
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
      http = Net::HTTP.new(host, 8443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @headers = {
            'HTTP_AUTH_LOGIN' => user,
            'HTTP_AUTH_PASSWD' => pass,
            'Accept' => '*/*',
            'Content-Type' => 'text/xml',
          }
      res, data = http.post2(path, xml.target!, @headers)
      return res.body
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
