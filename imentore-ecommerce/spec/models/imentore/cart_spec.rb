require "spec_helper"

describe Imentore::Cart do
  before do
    @cart = Imentore::Cart.new
  end

  it "has items" do
    @cart.items = { p1: { v1: 1 }, p2: { v2: 1 } }
    @cart.items.should have(2).items
  end

  it "is empty if has no items" do
    @cart.empty?.should be_true
  end

  it "is not empty if has at least one item" do
    @cart.items = { p1: { v1: 1 } }
    @cart.empty?.should be_false
  end

  it "adds an item" do
    @cart.add("p1", "v1", "2")
    cart = Imentore::Cart.first
    cart.items["p1"]["v1"].should eq("2")
  end
end
