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

Given "I add a product to my cart" do
  @product = @store.products.first

  click_link @product.name
  click_button "Add to cart"
end

Then "it appears in the items list" do
  page.should have_content(@product.name)
end
