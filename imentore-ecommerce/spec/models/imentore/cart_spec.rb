require "spec_helper"

describe Imentore::Cart do
  before do
    @cart = Imentore::Cart.new
  end

  it "has a session_id" do
    @cart.session_id = 123
    @cart.session_id.should eq(123)
  end

  it "has items" do
    @cart.items = [1, 2]
    @cart.items.should have(2).items
  end

  it "is empty if has no items" do
    @cart.empty?.should be_true
  end

  it "is not empty if has at least one item" do
    @cart.items = [1]
    @cart.empty?.should be_false
  end
end
