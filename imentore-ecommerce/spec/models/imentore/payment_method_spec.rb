require "spec_helper"

describe Imentore::PaymentMethod do
  let(:payment_method) { subject }

  it "has name" do
    payment_method.name = "Cielo"
    payment_method.name.should eq("Cielo")
  end

  it "has options" do
    payment_method.options = { token: "123" }
    payment_method.options.should eq({ token: "123" })
  end

  it "has store_id" do
    payment_method.store_id = 1
    payment_method.store_id.should eq(1)
  end

  it "has handle" do
    payment_method.handle = "cielo"
    payment_method.handle.should eq("cielo")
  end
end
