require 'spec_helper'

describe Imentore::StoresController do
  describe "#create" do
    context "given valid attributes" do
      before { post(:create, store_attrs) }

      it "creates a store" do
        Imentore::Store.count.should eq(2)
      end

      it "redirects to success" do
        response.should redirect_to(store_success_path)
      end
    end
  end
end

def store_attrs(attrs = {})
  { imentore_store: {
    url: 'url',
    owner_attributes: {
      user_attributes: {
        email: 'john@doe.com',
        password: 'secret',
        password_confirmation: 'secret'
  }}}}.merge(attrs)
end