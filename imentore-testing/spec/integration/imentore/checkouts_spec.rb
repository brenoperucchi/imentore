require_relative "../../../lib/imentore-testing/rails_helper"

describe "Checkout", :type => :feature do
  # Capybara.default_host = 'http://myshop.imentore.dev'
  context "#confirm" do
    let(:store) { FactoryGirl.create(:store_test) }
    it "places an order" do
      visit root_url(host: "#{store.url}.imentore.dev")
      click_link "Produto Exemplo"
      click_button "Adicionar"
      click_link "Finalizar Carrinho"
      fill_in("order_customer_name", with: "name test")
      fill_in("order_customer_email", with: "john@doe.com")
      fill_in("order_shipping_address_name", with: "title")
      fill_in("order_shipping_address_street", with: "street")
      fill_in("order_shipping_address_complement", with: "complement")
      fill_in("order_shipping_address_city", with: "city")
      select('Tocantins' , from: "order_shipping_address_state")
      select('Brazil' , from: "order_shipping_address_country")
      fill_in("order_shipping_address_zip_code", with: "88010002")
      fill_in("order_shipping_address_phone", with: "111-11111")
      click_button "Próximo"
      choose("order_delivery_attributes_delivery_method_id_1")
      click_button "Próximo"
      choose("order_invoice_attributes_payment_method_id_4")
      click_button "Próximo"
      expect(page).to have_content("Status Pedido")
      # save_and_open_page
    end
  end
end