require 'spec_helper'

describe "Imentore::DomainsController" do
	describe "#create" do
		it "returns the specified value on any instance of the class" do
		  Imentore::Domain.any_instance.stub(:add_domain_plesk).and_return(Imentore::Domain)
		  # o = Object.new
		  # o.foo.should eq(:return_value)
		end
	end
end