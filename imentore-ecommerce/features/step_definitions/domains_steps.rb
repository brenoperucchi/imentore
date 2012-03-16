Given /^I go to the page to create new domain$/ do
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

When /^I delete myshop\.com$/ do
  click_button "Destroy"
end

Then /^I should not see myshop\.com$/ do
  page.should_not have_content "myshop.com"
end

Given /^I create Myshop\.com with option hosting$/ do
  check("imentore_domain_hosting")
end

Then /^I should see status ok$/ do
  pending # express the regexp above with the code you wish you had
end

When "I create a new domain" do
  click_link "Domains"
  fill_in("Name", with: "myshop.biz")
  click_button "Create Domain"
end

Then "it appears in the domains list" do
  page.should have_content("myshop.biz")
end

Given "the store owns the domain myshop.com" do
  @store.domains.create(name: "myshop.com")
end

When "I go to myshop.com" do
  visit root_url(host: "myshop.com")
end

Then "I see the store's home page" do
  page.should have_content("Welcome to MyShop")
end

When "I go to the domain listing" do
  click_link "Domains"
  page.should have_content("myshop.com")
end

Then "I can delete it" do
  click_button "Destroy"
  page.should_not have_content("myshop.com")
end