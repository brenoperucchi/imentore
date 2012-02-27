When /^I go to the new theme page$/ do
  click_link "Themes"
  page.should have_content("New Theme")
  click_link "New Theme"
end

When /^create a theme called "([^"]*)"$/ do |theme_name|
  fill_in("Name", with: theme_name)
  click_button "Create Theme"
end

Then /^I should see Ocean's details page$/ do
  page.should have_content("Ocean")
end