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

  it "has a status" do
    order.status = "open"
    order.status.should eq("open")
  end

  it "has a customer email" do
    order.customer_email = "foo@bar.com"
    order.customer_email.should eq("foo@bar.com")
  end

  it "has items" do
    order.items = [1, 2, 3]
    order.items.should eq([1, 2, 3])
  end

  it "has an invoice" do
    order.should have_one(:invoice)
  end

  it "has a delivery" do
    delivery = Imentore::Delivery.new
    order.delivery = delivery
    order.delivery.should eq(delivery)
  end

  it "has a store" do
    order.should belong_to(:store)
  end

  describe "#total_amount" do
    it "is the sum of its items prices" do
      order.stub(items: [mock(:product, price: 12), mock(:product, price: 18)])

      order.total_amount.should eq(30)
    end
  end

  describe "#chargeable?" do
    it "is true when total amount greater than zero" do
      order.stub(total_amount: 12)
      order.chargeable?.should be_true
    end

    it "is false when total amount not greater than zero" do
      order.stub(total_amount: 0)
      order.chargeable?.should be_false
    end
  end

  describe "#deliverable?" do
    it "is true when all items are deliverable" do
      order.stub(items: [mock(:product, deliverable?: true)])

      order.deliverable?.should be_true
    end

    it "is false when one or more items aren't deliverable" do
      order.stub(items: [mock(:product, deliverable?: true), mock(:product, deliverable?: false)])

      order.deliverable?.should be_false
    end
  end
end
