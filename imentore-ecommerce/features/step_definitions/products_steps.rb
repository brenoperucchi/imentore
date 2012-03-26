When "I create a product" do
  click_link "Products"
  click_link "Add Product"
  fill_in("Name", with: "RUNNERS Magazine")
  fill_in("Description", with: "All about running!")
  fill_in("Price", with: "10.00")
  fill_in("Quantity", with: "50")
  fill_in("Weight", with: "0.3")
  click_button "Create Product"
  page.should have_content("Product was successfully created.")

end

Then "it appears in the product list" do
  page.should have_content("RUNNERS Magazine")
end
