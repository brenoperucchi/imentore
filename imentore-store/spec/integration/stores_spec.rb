require 'spec_helper'

describe "Stores" do
  describe "#new" do
    it "shows the form to create a new store" do
      visit new_store_path
      page.should have_selector('form#new_imentore_store')
      page.should have_field('Url')
      page.should have_field('Email')
      page.should have_field('Password')
      page.should have_field('Password confirmation')
      page.should have_button('Create Store')
    end
  end

  describe "#create" do
    context "given empty form" do
      before do
        visit new_store_path
        click_button 'Create Store'
      end

      it "shows error url can't be blank" do
        find('.url').should have_content("can't be blank")
      end

      it "shows error email can't be blank" do
        find('.email').should have_content("can't be blank")
      end

      it "shows error password can't be blank" do
        find('.password').should have_content("can't be blank")
      end
    end

    context "given an url used by other store" do
      before do
        visit new_store_path
        fill_in('Url', with: 'myshop')
        click_button 'Create Store'
      end

      it "shows error url has already been taken" do
        find('.url').should have_content('has already been taken')
      end
    end
  end
end