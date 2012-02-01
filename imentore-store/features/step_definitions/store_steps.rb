Given /^I am a visitor$/ do
  visit destroy_user_session_path
end

Given /^I am on the form to create a new store$/ do
  visit new_store_path
end

When /^I fill in and submit the form$/ do
  fill_in('Url', with: 'myshop')
  fill_in('Email', with: 'john@doe.com')
  fill_in('Password', with: 'secret')
  fill_in('Password confirmation', with: 'secret')
  click_button "create-store"
end

Then /^I should see "([^"]*)"$/ do |arg1|
  page.should have_content(arg1)
end