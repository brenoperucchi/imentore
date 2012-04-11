require "spec_helper"

describe Imentore::Invoice do
  let(:invoice) { subject }

  it "has amount" do
    invoice.amount = 12
    invoice.amount.should eq(12)
  end

  it "has payment method" do
    invoice.payment_method = :cielo
    invoice.payment_method.should eq(:cielo)
  end

  it "has status" do
    invoice.status = :open
    invoice.status.should eq(:open)
  end

  it "has provider_id" do
    invoice.provider_id = 123
    invoice.provider_id.should eq(123)
  end

  it "has order_id" do
    invoice.order_id = 123
    invoice.order_id.should eq(123)
  end
end
