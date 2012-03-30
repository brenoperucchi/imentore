When "I click on the checkout button" do
  click_button "Checkout"
end

When "I fill in my contact and payment information" do
  fill_in("Contact email", with: "john@doe.com")
end

When "I place the order" do
  pending
end

Then "I see order receipt" do
  pending
end
