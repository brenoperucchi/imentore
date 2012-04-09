require "spec_helper"

describe Imentore::CheckoutsController do
  let(:store)   { FactoryGirl.create(:myshop) }
  let(:cart)    { mock("cart", items: %w(item#1 item#2)) }
  let(:order)   { mock("order", total_amount: 15) }

  before do
    request.host = "#{store.url}.imentore.dev"
    subject.stub(current_cart: cart, current_order: order)
  end

  def orders_params(params = {})
    {
      customer_email: "john@doe.com",
      billing_address: { street: "123 Test St." },
      shipping_address: { street: "123 Test St." },
      delivery_method: "fedex",
      payment_method: "cielo"
    }
  end

  describe "#new" do
    it "updates order items" do
      order.should_receive(:update_attribute).with(:items, cart.items)

      get(:new)

      subject.should render_template("new")
    end
  end

  describe "#confirm" do
    it "places an order" do
      order.should_receive(:place)

      put(:confirm, order: orders_params)

      subject.should render_template("confirm")
    end
  end
end
