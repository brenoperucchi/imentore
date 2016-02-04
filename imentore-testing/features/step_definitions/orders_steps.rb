When "I go to the checkout page" do
  click_link "My Cart"
  click_link "Checkout"
end

When "I fill in my contact and payment information" do
  fill_in("Customer email", with: "john@doe.com")
  within("#billing-address") do
    fill_in("Street", with: "123 Test St.")
    fill_in("Complement", with: "Madison Center")
    fill_in("City", with: "New York")
    fill_in("State", with: "NY")
    # fill_in("Country", with: "United States")
    fill_in("Zip code", with: "10000")
  end
  within("#shipping-address") do
    fill_in("Street", with: "123 Test St.")
    fill_in("Complement", with: "Madison Center")
    fill_in("City", with: "New York")
    fill_in("State", with: "NY")
    # fill_in("Country", with: "United States")
    fill_in("Zip code", with: "10000")
  end
end

When "I place the order" do
  click_button "Place order"
end

Then "I see order receipt" do
  page.should have_content("Order receipt")
end
