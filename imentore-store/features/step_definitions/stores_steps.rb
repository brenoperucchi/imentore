Given /^there is a store MyShop$/ do
  Factory.create(:myshop)
end

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