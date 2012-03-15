Given "there is a store" do
  @store = Factory.create(:myshop)
  Factory.create(:green_theme)
end

Given /^there is a store MyShop$/ do
  @store = Factory.create(:myshop)
  Factory.create(:green_theme)
end