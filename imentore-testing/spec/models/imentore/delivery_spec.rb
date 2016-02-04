require "spec_helper"

describe Imentore::Delivery do
  it "has order_id" do
    subject.order_id = 123
    subject.order_id.should eq(123)
  end

  it "has delivery_method" do
    delivery_method = Imentore::DeliveryMethod.new
    subject.delivery_method = delivery_method
    subject.delivery_method.should eq(delivery_method)
  end

  it "has tracking_code" do
    subject.tracking_code = 123
    subject.tracking_code.should eq(123)
  end

  it "has address" do
    subject.address = "123 St."
    subject.address.should eq("123 St.")
  end

  it "has status" do
    subject.status = "pending"
    subject.status.should eq("pending")
  end
end
