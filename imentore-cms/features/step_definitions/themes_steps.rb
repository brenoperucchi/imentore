When "I go to the new theme page" do
  click_link "Themes"
  page.should have_content("New Theme")
  click_link "New Theme"
end

When "create a theme called Ocean" do
  fill_in("Name", with: "Ocean")
  click_button "Create Theme"
end

Then "I should see its details page" do
  page.should have_content("Ocean")
end

Given "I am on the details page of the theme Ocean" do
  @theme = Imentore::Theme.create(name: "Ocean", store: @store)
  click_link "Themes"
  page.should have_content("Ocean")
  click_link "Ocean"
  find("h2.title").should have_content("Ocean")
end

When "I create a new default layout" do
  click_link "New Template"
  fill_in("Path", with: "layouts/ocean")
  fill_in("Body", with: "Default layout for Ocean")
  click_button "Create Template"
  find("h2.title").should have_content("Ocean")
  page.should have_content("layouts/ocean")
end

When "I go to myshop's home page" do
  visit root_url(host: "myshop.imentore.dev")
end

Then "I see my default layout" do
  page.should have_content("Default layout for Ocean")
end