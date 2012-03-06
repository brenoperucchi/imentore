Given /^they also own the domain myshop\.dev$/ do
  pending
end

When /^I go to myshop\.imentore\.dev$/ do
  Capybara.default_host = 'http://myshop.imentore.dev'
  visit root_path
end

Then /^I see the MyShop home page$/ do
  page.should have_content('Welcome to MyShop')
end

When /^I go to myshop\.dev$/ do
  Capybara.default_host = 'http://myshop.dev'
  visit root_path
end

When /^I go to a store that do not exists$/ do
  Capybara.default_host = 'http://oops.imentore.dev'
  visit root_path
end

Then /^I see a store not found error page$/ do
  page.should have_content("Store not found")
end

Given /^I am on the page to create a new store$/ do
  visit new_store_path
end

When /^I create my store$/ do
  fill_in("Url", with: "myshop")
  fill_in("Email", with: "owner@myshop.imentore.dev")
  fill_in("Password", with: "123123")
  fill_in("Password confirmation", with: "123123")
  click_button "Create Store"
end

Then /^I should see the congratulations page$/ do
  page.should have_content("Congrats!")
end

Given /^the owner is on its dashboard$/ do
  Capybara.default_host = 'http://myshop.imentore.dev'
  visit new_admin_session_path
  fill_in("Email", with: "owner@myshop.imentore.dev")
  fill_in("Password", with: "123123")
  click_button "Sign in"
  visit admin_dashboard_path
end

When /^she access General Settings$/ do
  click_link "General Settings"
end

Then /^she should see the general settings form$/ do
  find('h2.page-title').should have_content("General Settings")
end

