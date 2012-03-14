require 'net/http'
require 'builder'

module Imentore
  PASS = 'plaszx12qw'

  class Plesk

    def self.domain_check_status(domain_name)
      host = "207.7.84.39"
      path = "/enterprise/control/agent.php"
      # params = File.open("#{RAILS_ROOT}/lib/plesk/add_domain.xml").read
      # params.gsub!(/(#[^#]+#)/){|name| tags[name]}
      # puts params
      xml = Builder::XmlMarkup.new(:target => out_string = "<?xml version='1.0' encoding='UTF-8'?>\n", :indent =>2)
      xml.packet(:version => "1.6.0.2") do
        xml.site{
          xml.get{
            xml.filter{
              xml.name(domain_name)
            }
            xml.dataset{
              xml.gen_info
            }
          }
        }
      end
      puts out_string
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
      puts res.body
      return res.body
      # return xml
    end

    def self.enable_domain_mail(domain_id)
      host = "207.7.84.39"
      path = "/enterprise/control/agent.php"
      # params = File.open("#{RAILS_ROOT}/lib/plesk/add_domain.xml").read
      # params.gsub!(/(#[^#]+#)/){|name| tags[name]}
      # puts params
      xml = Builder::XmlMarkup.new(:target => out_string = "<?xml version='1.0' encoding='UTF-8'?>\n", :indent =>2)
      xml.packet(:version => "1.4.2.0") {
        xml.mail{
          xml.enable{
            xml.domain_id(domain_id)
          }
        }
      }
      puts out_string
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
      puts res.body
      return res.body
      # return xml
    end
  end
end