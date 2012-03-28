When "I go to my cart" do
  click_link("My Cart")
end

Then "I see a message saying its empty" do
  page.should have_content("Your cart is empty.")
end
