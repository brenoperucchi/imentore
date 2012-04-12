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
  # stub_request(:any, "plesk.com").to_return(:body => "abc", :status => 200,  :headers => { 'Content-Length' => 3 } )

  describe "#add_domain" do
    it "raises PleskError when connection refused error" do
      plesk.host = "http://imentore.com.br:22"
      expect { plesk.add_domain }.to raise_error(Imentore::PleskException)
    end

    it "raises PleskError when DNS error" do
      plesk.host = "http://nao-existe.co"
      expect { plesk.add_domain }.to raise_error(Imentore::PleskException)
    end

    it "raises PleskError on timeout" do
      plesk.host = "http://imentore.com.br"
      plesk.timeout = 0.3
      expect { plesk.add_domain }.to raise_error(Imentore::PleskException)
    end

    it "raises PleskError on API system error" do
      plesk.host = "http://imentore.com.br"
      plesk.rpc_version = '1.40.2.0'
      expect { plesk.add_domain }.to raise_error(Imentore::PleskException)
      
    end

    # it "raises PleskError on agent error" do
    #   plesk.host = "imentore.com.br"
    #   plesk.rpc_version = '1.6.0.2'
    #   expect { plesk.add_domain }.to raise_error(Imentore::PleskException)
    # end

    it "raises PleskError on wrong username" do
      plesk.user = "test"
      plesk.host = 'imentore.com.br'
      response = plesk.add_domain 
      response.success?.should be_false
      response.code.should be == "1001"
    end

    it "raises PleskError on wrong password" do
      plesk.user = "admin"
      plesk.pass = "123"
      plesk.host = 'imentore.com.br'
      response = plesk.add_domain 
      response.success?.should be_false
      response.code.should be == "1001"
    end

    it "raises PleskError on domain already exist" do
      response = plesk.add_domain('imentore.com.br')
      response.success?.should be_false
      response.code.should be == "1007"

    end

    it "can add a domain" do
      response = plesk.add_domain(domain_name)
      @@plesk_id = response.plesk_id
      response.success?.should be_true
    end

    it "can add mail account on domain" do
      response = plesk.add_mail_domain(@@plesk_id, mail_name, mail_password)
      response.success?.should be_true
    end

    it "'can change mail account password'" do
      response = plesk.change_mail_domain(@@plesk_id, mail_name, "321321")
      response.success?.should be_true
    end

    it "can remove mail account on domain" do
      response = plesk.del_mail_domain(@@plesk_id, mail_name)
      response.success?.should be_true
    end

    it "can be enable mail domain " do
      response = plesk.enable_mail_domain(@@plesk_id)
      response.success?.should be_true      
    end

    it "can be disable mail domain " do
      response = plesk.disable_mail_domain(@@plesk_id)
      response.success?.should be_true      
    end

    it "can remove domain" do
      response = plesk.del_domain(@@plesk_id)
      response.success?.should be_true
    end

  end
end