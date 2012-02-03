require 'spec_helper'

describe "Stores" do
  describe "#new" do
    it "shows the form to create a new store" do
      visit new_store_path
      page.should have_field('Url')
      page.should have_field('Email')
      page.should have_field('Password')
      page.should have_field('Password confirmation')
      page.should have_button('Create Store')
    end
  end
end