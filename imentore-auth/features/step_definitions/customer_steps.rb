Given /^I go to create new customer$/ do
  click_link "New Customer"
end

Then /^I should see notification of created customer$/ do
  fill_in("customer_name", with: "test")
  fill_in("customer_brand", with: "test")
  fill_in("customer_irs_id", with: "test")
  select("2012", from: "customer_birthdate_1i")
  select("May", from: "customer_birthdate_2i")
  select("3", from: "customer_birthdate_3i")
  fill_in("customer_national_id", with: "test")
  fill_in("customer_gender", with: "test")
  choose("customer_person_type_person")
  fill_in("customer_user_attributes_email", with:"client@myshop.com")
  fill_in("customer_user_attributes_password", with:"123123")
  fill_in("customer_user_attributes_password_confirmation", with:"123123")
  click_button "Create Customer"
  page.should have_content("created customer")
end

Given /^I go to login in customer dashboard$/ do
  step "I go to create new customer"
  step "I should see notification of created customer"
  # click_link("Login")
  fill_in("user_email", with:"client@myshop.com")
  fill_in("user_password", with:"123123")
  click_button("sign_in")
end

Then /^I see the Dashboard Gretting$/ do
  page.should have_content("Dashboard")
end

