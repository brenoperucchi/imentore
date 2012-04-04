require "spec_helper"

describe "Checkout" do
  context "#confirm" do
    let(:store) { FactoryGirl.create(:myshop) }

    before do
      FactoryGirl.create(:green_theme)
    end

    it "places an order" do
      visit root_url(host: "#{store.url}.imentore.dev")
      click_link "I <3 NY mug"
      click_button "Add to cart"
      click_link "Checkout"
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
      click_button "Place order"

      order = store.orders.first
      order.total_amount.should eq(15)
      order.invoice.should be
      order.delivery.should be
      order.status.should eq("placed")
    end
  end
end
