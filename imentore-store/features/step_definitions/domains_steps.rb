Given /^I am on the page to create new domain$/ do
  visit admin_domains_url(host: 'myshop.imentore.dev')
  page.should have_content("List Domains")
end

When /^I create myshop\.com domain$/ do
  page.should have_content("Create Domain")
  fill_in("imentore_domain_name", with: "myshop.com")
  click_button "Create Domain"
end

Then /^I should see myshop\.com created$/ do
  page.should have_content("myshop.com")
end

When /^I access www\.myshop\.com domain$/ do
  visit root_url(host: 'www.myshop.com')
end

Then /^I should see MyShop home page$/ do
  page.should have_content("MyShop!")
end