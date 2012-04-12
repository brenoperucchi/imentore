require 'spec_helper'

describe Imentore::Admin::DomainsController do
	describe "#create" do
		before do
		  Factory.create(:myshop)
		  request.host = "myshop.imentore.dev"
		  subject.stub(check_store: true, authorize_admin: true)
		end
		
		it "returns the specified value on any instance of the class" do
		  Imentore::Plesk.any_instance.should_receive(:add_domain).and_return(true)
		  post(:create)
		  # o = Object.new
		  # o.foo.should eq(:return_value)
		end
	end
end