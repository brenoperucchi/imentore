Given /^I am at the green theme detalis page$/ do
  # Factory.create(:green_theme)
  click_link "Themes"
  click_link "green"
end

When /^I should create new asset$/ do
  click_link "New Asset"
  @asset = Imentore::Asset.create(file: File.open("#{ENV['RAILS_ROOT']}/public/test_file.png"), theme: @store.themes.first)
  Imentore::Asset.all.size.should eq(1)
end

Then /^I should destroy the asset$/ do
  pending# Pedir para Vinicius ajudar aqui
  click_link "Destroy"
end
