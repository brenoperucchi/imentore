Given /^I am at the green theme detalis page$/ do
  # Factory.create(:green_theme)
  click_link "Themes"
  click_link "green"
end

When /^I create new asset$/ do
  pending
  click_link "New Asset"
  attach_file("File", File.expand_path("public/favicon.ico", Rails.root))
  click_button "Enviar Arquivo"
end

Then "I see it in the assets list" do
  pending
  page.should have_content("favicon.ico")
end

Given "there is the favicon image" do
  theme = @store.theme
  theme.assets.create(file: File.open(File.expand_path("public/favicon.ico", Rails.root)))
end

When "I delete it" do
  click_link "Destroy"
end

Then "it does not appear in the assets list" do
  page.should_not have_content("favicon.ico")
end
