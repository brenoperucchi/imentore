When "I go to my cart" do
  click_link("My Cart")
end

Then "I see a message saying its empty" do
  page.should have_content("Your cart is empty.")
end

Given "my cart is not empty" do
  @product = @store.products.first
  variant = @product.variants.first
  cart = Imentore::Cart.first
  cart.add(@product, variant, 1)
end

Then "I see the list of items" do
  page.should have_content(@product.name)
end
