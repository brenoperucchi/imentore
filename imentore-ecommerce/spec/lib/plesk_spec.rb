require "spec_helper"
require "plesk"

describe Imentore::Plesk do

  let(:plesk) { Imentore::Plesk.new(nil) }
  let(:domain_name) { 'test'+rand(10) + '.com'}

  # stub_request(:any, "plesk.dev/conn-refused").to_raise(Errno::ECONNREFUSED)
  # stub_request(:any, "plesk.ved").to_raise(SocketError)

  describe "#add_domain" do
    it "raises PleskError when connection refused error" do
      plesk.url = "http://imentore.com.br:22"
      expect { plesk.add_domain }.to raise_error(Imentore::PleskError)
    end

    it "raises PleskError when DNS error" do
      plesk.url = "http://nao-existe.co"
      expect { plesk.add_domain }.to raise_error(Imentore::PleskError)
    end

    it "raises PleskError on timeout" do
      plesk.url = "http://imentore.com.br"
      plesk.timeout = 0.3
      expect { plesk.add_domain }.to raise_error(Imentore::PleskError)
    end

    # it "raises PleskError when whatever other error" do
    #   plesk.url = "http://imentore.com.br"
    #   plesk.timeout = 1
    #   expect { plesk.add_domain }.to raise_error(Imentore::PleskError)
    # end

    it "raises PleskError on API system error" do
      plesk.url = "http://imentore.com.br"
      plesk.rpc_version = '1.40.2.0'
      expect { plesk.add_domain }.to raise_error(Imentore::PleskError)
    end

    # it "raises PleskError on agent error" do
    #   plesk.url = "imentore.com.br"
    #   plesk.rpc_version = '1.6.0.2'
    #   expect { plesk.add_domain }.to raise_error(Imentore::PleskError)
    # end

    it "raises PleskError on wrong username" do
      plesk.user = "test"
      plesk.url = 'imentore.com.br'
      expect { plesk.add_domain }.to raise_error(Imentore::PleskError)
    end

    it "raises PleskError on wrong password" do
      plesk.pass = "123"
      plesk.url = 'imentore.com.br'
      expect { plesk.add_domain}.to raise_error(Imentore::PleskError)
    end

    it "raises PleskError on domain already exist" do
      plesk.url = 'imentore.com.br'
      expect { plesk.add_domain}.to raise_error(Imentore::PleskError)
    end

    it "can add a domain" do
      pending #
      # expect { plesk.add_domain(domain_name) }.to_not raise_error(Imentore::PleskError)
    end

    it "delete domain" do
      pending #
      # expect { plesk.delete_domain(domain_name) }.to_not raise_error(Imentore::PleskError)
    end

  end
end