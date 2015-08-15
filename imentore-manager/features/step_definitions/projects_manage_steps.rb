Given /^I am authenticated$/ do
  true
end

Given /^I am new project page/ do
  visit new_deal_project_path
end

Given /^I am create a project$/ do
  visit new_deal_project_path
  # click_link "Create Project"
  fill_in("project_name", with: "Name of Project")
  fill_in("project_description", with: "description Project")
  fill_in("project_budget", with: "1000")
  fill_in("project_estimated_of", with: "10")
  fill_in("project_duration_of", with: "1")
  click_button "Create Project"
end

Then /^I should see project listed$/ do
  page.should have_content("Name of Project")
end


Given /^I have a project created$/ do
  step %{I am create a project}
end

Given /^I made a propose to the project$/ do
  page.should have_content("Name of Project")
  click_link "Made propose"
  fill_in("propose_value", with:"10")
  fill_in("propose_description", with:"description")
  fill_in("propose_payment_description", with:"some")
  fill_in("propose_availability", with:"some")
  click_button "Create Propose"

end

Then /^I should see the propose$/ do
  page.should have_content ("10")
  page.should have_content ("description")
end
