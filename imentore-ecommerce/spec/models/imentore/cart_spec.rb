require "spec_helper"

describe Imentore::Cart do
  let(:cart) { subject }

  it "items is a serialized Array" do
    cart.items.should be_a(Array)
  end

  it "is empty if has no items" do
    cart.empty?.should be_true
  end

  it "is not empty if has at least one item" do
    cart.items << 1
    cart.empty?.should be_false
  end

  it "adds an item" do
    cart.add("p1", "v1", "2")
    item = cart.items.first

    item.product.should eq("p1")
    item.variant.should eq("v1")
    item.quantity.should eq(2)
  end
end
