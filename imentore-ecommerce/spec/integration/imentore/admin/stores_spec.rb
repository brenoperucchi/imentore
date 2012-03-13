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
      page.should have_field("Irs")
      page.should have_field("National")
      page.should have_field("Street")
      page.should have_field("Complement")
      page.should have_field("City")
      page.should have_field("State")
      page.should have_field("Country")
      page.should have_field("Zip code")
      page.should have_field("Phone")
      page.should have_button("Update Store")
    end
  end

  describe "#update" do
    it "changes the associated address" do
      visit edit_admin_store_path
      fill_in("Zip code", with: '00123')
      click_button "Update Store"
      find_field('Zip code').value.should eq('00123')
    end
  end
end