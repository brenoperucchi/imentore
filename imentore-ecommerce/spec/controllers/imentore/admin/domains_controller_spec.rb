require 'spec_helper'

describe Imentore::Admin::DomainsController do
  describe "#create" do
    let(:store) { FactoryGirl.create(:myshop) }

    before do
      subject.stub(check_store: true, authorize_admin: true, current_store: store)
    end

    it "returns the specified value on any instance of the class" do
      Imentore::Plesk.any_instance.should_receive(:add_domain).and_return(mock(:domain, success?: true, plesk_id: 123))

      post(:create, domain: { name: "imentore.com", hosting: "1" })
    end
  end
end
