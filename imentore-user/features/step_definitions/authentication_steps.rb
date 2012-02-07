Given /^there is a store named MyShop$/ do
  Factory.create(:myshop)
end

Given /^I am a visitor$/ do
  visit destroy_user_session_url
end

When /^I go to the admin login page$/ do
  Capybara.default_host = 'http://myshop.imentore.dev'
  visit new_admin_session_url
end

When /^login with the owner account$/ do
  fill_in('Email', with: 'owner@myshop.imentore.dev')
  fill_in('Password', with: '123123')
  click_button 'Sign in'
end

Then /^I should see the MyShop's dashboard$/ do
  page.should have_content("dashboard")
end