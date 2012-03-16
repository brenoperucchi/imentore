require "spec_helper"

describe Imentore::Admin::StoresController do
  before do
    Factory.create(:myshop)
    request.host = "myshop.imentore.dev"
    subject.stub(check_store: true, authorize_admin: true)
  end

  describe "#update" do
    it "redirects to dashboard" do
      put(:update, imentore_store: { url: 'url', brand: 'brand' })
      response.should redirect_to(edit_admin_store_path)
      flash[:success].should be
    end
  end
end