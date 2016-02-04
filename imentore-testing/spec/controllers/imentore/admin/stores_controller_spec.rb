require "spec_helper"

describe Imentore::Admin::StoresController do
  let(:store) { FactoryGirl.create(:myshop) }

  before do
    subject.stub(check_store: true, authorize_admin: true, current_store: store)
  end

  describe "#update" do
    it "redirects to dashboard" do
      put(:update, store: { url: 'url', brand: 'brand' })

      response.should redirect_to(edit_admin_store_path)
      flash[:success].should be
    end
  end
end
