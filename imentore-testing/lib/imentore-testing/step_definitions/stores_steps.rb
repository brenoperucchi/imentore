Given /^there is a store MyShop$/ do
  @store = Factory.create(:myshop)
  Factory.create(:green_theme)
end