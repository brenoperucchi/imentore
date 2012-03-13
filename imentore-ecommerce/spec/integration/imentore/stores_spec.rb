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

  describe "#show" do
    it "renders show when store exists" do
      store = Factory.create(:myshop)
      Factory.create(:green_theme, store: store)
      get "http://myshop.imentore.dev"
      response.status.should eq(200)
      response.should render_template('show')
    end

    it "gives 404 when store not found" do
      get "http://oops.imentore.dev"
      response.status.should eq(404)
      response.should render_template('not_found')
    end
  end
end