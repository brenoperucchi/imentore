require_relative "../../spec_helper"

describe Imentore::Cart do
  let(:cart) { subject }

  it "items is a serialized Array" do
    expect(cart.items).to be_a(Array)
  end

  it "is empty if has no items" do
    expect(cart.empty?).to be_truthy
  end

  it "is not empty if has at least one item" do
    cart.items << 1
    expect(cart.empty?).to be_falsey
  end

  it "adds an item" do
    cart.add("p1", "v1", "2")
    item = cart.items.first

    expect(item.product).to eq("p1")
    expect(item.variant).to eq("v1")
    expect(item.quantity).to eq(2)
  end
end