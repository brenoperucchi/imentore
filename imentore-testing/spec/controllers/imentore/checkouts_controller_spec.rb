require "spec_helper"

describe Imentore::CheckoutsController do
  let(:store)   { FactoryGirl.create(:myshop) }
  let(:cart)    { mock("cart", items: %w(item#1 item#2)) }
  let(:order)   { mock("order", total_amount: 15) }

  before do
    subject.stub(current_cart: cart, current_order: order, current_store: store)
  end

  def orders_params(params = {})
    {
      customer_email:   "john@doe.com",
      billing_address:  { "street" => "123 Test St." },
      shipping_address: { "street" => "123 Test St." },
      delivery_method:  "fedex",
      payment_method:   "cielo"
    }.stringify_keys
  end

  describe "#confirm" do
    context "places an order" do
      before do
        Imentore::CheckoutService.should_receive(:place_order).with(order, orders_params)
      end

      context "when chargeable order" do
        it "redirect to charge" do
          order.stub(chargeable?: true)

          put(:confirm, order: orders_params)

          subject.should redirect_to(charge_checkout_path)
        end
      end

      context "when giveaway order" do
        it "redirect to complete page" do
          order.stub(chargeable?: false)

          put(:confirm, order: orders_params)

          subject.should redirect_to(complete_checkout_path)
        end
      end
    end
  end
end
