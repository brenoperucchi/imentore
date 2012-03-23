require "spec_helper"
require "plesk"

describe Imentore::Plesk do

  let(:plesk) { Imentore::Plesk.new }
  # let(:domain_name) { 'test.com'}
  let(:domain_name) { 'test' + rand(10).to_s + '.com'}
  let(:mail_name) { 'test_user' }
  let(:mail_password) { '123123' }

  # stub_request(:any, "plesk.dev/conn-refused").to_raise(Errno::ECONNREFUSED)
  # stub_request(:any, "plesk.ved").to_raise(SocketError)

  describe "#add_domain" do
    it "raises PleskError when connection refused error" do
      plesk.host = "http://imentore.com.br:22"
      expect { plesk.add_domain }.to raise_error(Imentore::PleskError)
    end

    it "raises PleskError when DNS error" do
      plesk.host = "http://nao-existe.co"
      expect { plesk.add_domain }.to raise_error(Imentore::PleskError)
    end

    it "raises PleskError on timeout" do
      plesk.host = "http://imentore.com.br"
      plesk.timeout = 0.3
      expect { plesk.add_domain }.to raise_error(Imentore::PleskError)
    end

    # it "raises PleskError when whatever other error" do
    #   plesk.host = "http://imentore.com.br"
    #   plesk.timeout = 1
    #   expect { plesk.add_domain }.to raise_error(Imentore::PleskError)
    # end

    it "raises PleskError on API system error" do
      plesk.host = "http://imentore.com.br"
      plesk.rpc_version = '1.40.2.0'
      expect { plesk.add_domain }.to raise_error(Imentore::PleskError)
    end

    # it "raises PleskError on agent error" do
    #   plesk.host = "imentore.com.br"
    #   plesk.rpc_version = '1.6.0.2'
    #   expect { plesk.add_domain }.to raise_error(Imentore::PleskError)
    # end

    it "raises PleskError on wrong username" do
      plesk.user = "test"
      plesk.host = 'imentore.com.br'
      expect { plesk.add_domain }.to raise_error(Imentore::PleskError)
    end

    it "raises PleskError on wrong password" do
      plesk.pass = "123"
      plesk.host = 'imentore.com.br'
      expect { plesk.add_domain}.to raise_error(Imentore::PleskError)
    end

    it "raises PleskError on domain already exist" do
      expect { plesk.add_domain("imentore.com.br")}.to raise_error(Imentore::PleskError)
    end

    it "can add a domain" do
      @@result = plesk.add_domain(domain_name)
      @@result.status.should be  == "ok"
    end

    it "can add mail on domain" do
      result_mail = plesk.add_mail_domain(@@result.plesk_id, mail_name, mail_password)
      result_mail.status.should be  == "ok"
    end

    it "can remove mail on domain" do
      result_mail = plesk.del_mail_domain(@@result.plesk_id, mail_name)
      result_mail.status.should be  == "ok"
    end

    it "can remove domain" do
      @@result = plesk.del_domain(@@result.plesk_id)
      @@result.status.should be == "ok"
    end


  end
end