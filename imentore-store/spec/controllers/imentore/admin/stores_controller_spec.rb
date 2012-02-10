require "spec_helper"

describe Imentore::Admin::StoresController do
  before do
    Factory.create(:myshop)
    request.host = "myshop.imentore.dev"
  end

  describe "#update" do
    it "redirects to dashboard" do
      put(:update, imentore_store: { url: 'url', brand: 'brand' })
      response.should redirect_to(admin_dashboard_path)
    end
  end
end