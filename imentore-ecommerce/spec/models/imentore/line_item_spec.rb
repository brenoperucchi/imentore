require "spec_helper"

describe Imentore::LineItem do
  let(:variant) { mock(:variant, price: 12) }
  let(:item)    { Imentore::LineItem.new("mug", variant, 2) }

  it "has product" do
    item.product.should eq("mug")
  end

  it "has variant" do
    item.variant.should be(variant)
  end

  it "has quantity" do
    item.quantity.should eq(2)
  end

  it "has price" do
    item.price.should eq(12)
  end
end
