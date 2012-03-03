Given /^I am on the page to create new domain$/ do
	Capybara.default_host = 'http://myshop.imentore.dev'
	visit admin_domains_path
	page.should have_content("Create Domain")
end

When /^I create myshop\.com domain$/ do
	Capybara.default_host = 'http://myshop.imentore.dev'	
	fill_in("name", with: "myshop.com")
	click_button "Create Domain"
end

Then /^she should see myshop\.com created$/ do
	page.should have_content("myshop.com")
end
