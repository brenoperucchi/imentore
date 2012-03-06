Given /^I am on the page to create new domain$/ do
  # Capybara.default_host = 'http://myshop.imentore.dev'
  visit admin_domains_path(:host => 'myshop.imentore.dev')
  page.should have_content("List Domains")
end

When /^I create myshop\.com domain$/ do
  # Capybara.default_host = 'http://myshop.imentore.dev'
  page.should have_content("Create Domain")
  fill_in("imentore_domain_name", with: "myshop.com")
  click_button "Create Domain"
end

Then /^I should see myshop\.com created$/ do
  page.should have_content("myshop.com")
end
