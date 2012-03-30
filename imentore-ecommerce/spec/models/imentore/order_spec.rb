require "spec_helper"

describe Imentore::Order do
  let(:order) { subject }

  it "has a shipping address" do
    order.shipping_address = Imentore::Address.new(street: "123 Test St.")
    order.shipping_address.street.should eq("123 Test St.")
  end

  it "has a billing address" do
    order.billing_address = Imentore::Address.new(street: "123 Test St.")
    order.billing_address.street.should eq("123 Test St.")
  end

  it "has a total amount" do
    order.total_amount = 123
    order.total_amount.should eq(123)
  end

  it "has a status" do
    order.status = "open"
    order.status.should eq("open")
  end

  it "has a buyer email" do
    order.buyer_email = "foo@bar.com"
    order.buyer_email.should eq("foo@bar.com")
  end

  it "has items" do
    order.items = [1, 2, 3]
    order.items.should eq([1, 2, 3])
  end

  it "has an invoice" do
    order.invoice = "invoice"
    order.invoice.should eq("invoice")
  end

  it "has a shipment" do
    order.shipment = "shipment"
    order.shipment.should eq("shipment")
  end
end
