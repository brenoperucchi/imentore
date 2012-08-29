Given /^there in the land Deal page$/ do
  visit deal_path
end

Given /^I could access dashboard$/ do
  visit deal_path
end

Given /^I can created dealer with talent$/ do
  click_link "Create Talent"
  fill_in("dealer_email", with: "test@test.com")
  fill_in("dealer_password", with: "123123")
  fill_in("dealer_password_confirmation", with: "123123")
  fill_in("dealer_talents_attributes_0_name", with: "Talent name")
  fill_in("dealer_talents_attributes_0_kind", with: "kind")
  fill_in("dealer_talents_attributes_0_experience", with: "experience")
  fill_in("dealer_talents_attributes_0_resume", with: "resume")
  fill_in("dealer_talents_attributes_0_description", with: "description")
  click_button "Create Dealer"
end

Then /^I should see talent created$/ do
  page.should have_content("Talent name")
end


Given /^I am the login page$/ do
  visit new_deal_admin_session_url
end

Given /^I fill form login$/ do
  fill_in("dealer_email", with: "test@test.com")
  fill_in("dealer_password", with: "123123")
  click_button "Sign in"
end

Then /^I am access admin dealer dashbord$/ do
  page.should have_content "Admin Dashboard"
end


# Given /^I could access dashboard$/ do
#   visit deal_path
# end

# Then /^I should see Dashboard$/ do
#   pending # express the regexp above with the code you wish you had
# end

# Given /^I am at the green theme detalis page$/ do
#   # Factory.create(:green_theme)
#   click_link "Themes"
#   click_link "green"
# end

# When /^I create new asset$/ do
#   pending
#   click_link "New Asset"
#   attach_file("File", File.expand_path("public/favicon.ico", Rails.root))
#   click_button "Enviar Arquivo"
# end

# Then "I see it in the assets list" do
#   pending
#   page.should have_content("favicon.ico")
# end

# Given "there is the favicon image" do
#   theme = @store.theme
#   theme.assets.create(file: File.open(File.expand_path("public/favicon.ico", Rails.root)))
# end

# When "I delete it" do
#   click_link "Destroy"
# end

# Then "it does not appear in the assets list" do
#   page.should_not have_content("favicon.ico")
# end
