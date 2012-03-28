Given "there is a store" do
  @store = Factory.create(:myshop)
  Factory.create(:green_theme)
end

Given "I am on its home page" do
  visit root_url(host: "#{@store.url}.imentore.dev")
end

Given /^there is a store MyShop$/ do
  @store = Factory.create(:myshop)
  Factory.create(:green_theme)
end
