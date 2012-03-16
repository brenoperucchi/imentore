require 'spec_helper'

describe "Admin::Stores" do
  before do
    Factory.create(:myshop)
    Factory.create(:green_theme)
    sign_in_as_owner
  end

  describe "#edit" do
    it "shows the form" do
      visit edit_admin_store_url(host: "myshop.imentore.dev")
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
      visit edit_admin_store_url(host: "myshop.imentore.dev")
      fill_in("Zip code", with: '00123')
      click_button "Update Store"
      find_field('Zip code').value.should eq('00123')
    end
  end
end

def sign_in_as_owner
  visit admin_session_url(host: "myshop.imentore.dev")
  fill_in("Email", with: "owner@myshop.imentore.dev")
  fill_in("Password", with: "123123")
  click_button "Sign in"
end