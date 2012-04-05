Given /^I am at the green theme detalis page$/ do
  click_link "Themes"
  click_link "green"
end

When /^I create new asset$/ do
  click_link "New Asset"
end

Then /^I see it in the assets list$/ do
  pending # express the regexp above with the code you wish you had
end
