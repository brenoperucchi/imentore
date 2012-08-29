Given /^I am new talent page$/ do
  visit new_deal_talent_path
end

Given /^I am create talent service$/ do
  # click_link "Create Talent"
  fill_in("talent_name", with: "talent name")
  fill_in("talent_kind", with: "some")
  fill_in("talent_experience", with: "some")
  fill_in("talent_resume", with: "some")
  fill_in("talent_description", with: "some")
  click_button "Create Talent"
end

Then /^I should see listed dashboard deal$/ do
  page.should have_content("talent name")
end