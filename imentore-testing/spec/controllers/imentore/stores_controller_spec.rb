require 'spec_helper'

describe Imentore::StoresController do
  before do
    @store = Factory.create(:myshop)
    Factory.create(:green_theme)
    subject.stub(check_store: true, authorize_admin: true, current_store: @store)
  end

  describe "#show" do
    it "has the list of products" do
      get :show
      assigns(:products).should be
    end
  end

  describe "#create" do
    context "given valid attributes" do
      before { post(:create, store_attrs) }

      it "creates a store, owner and user" do
        store = Imentore::Store.last
        store.url.should eq('url')

        store.owner.should be

        user = store.owner.user
        user.email.should eq('john@doe.com')
      end

      it "redirects to success" do
        response.should redirect_to(store_success_path)
      end
    end
  end
end

def store_attrs(attrs = {})
  { store: {
    url: 'url',
    owner_attributes: {
      user_attributes: {
        email: 'john@doe.com',
        password: 'secret',
        password_confirmation: 'secret'
  }}}}.merge(attrs)
end
