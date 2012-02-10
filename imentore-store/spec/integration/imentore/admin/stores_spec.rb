require 'spec_helper'

describe "Admin::Stores" do
  before do
    Factory.create(:myshop)
    Capybara.default_host = "http://myshop.imentore.dev"
  end

  describe "#edit" do
    it "shows the form" do
      visit edit_admin_store_path
      find('form')['action'].should eq(admin_store_path)
      page.should have_field("Name")
      page.should have_field("Brand")
      page.should have_field("Url")
      page.should have_button("Update Store")
    end
  end
end