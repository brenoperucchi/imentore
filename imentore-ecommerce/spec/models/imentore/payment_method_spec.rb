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

  it "references a store" do
    store = Imentore::Store.new
    payment_method.store = store
    payment_method.store.should eq(store)
  end

  it "has handle" do
    payment_method.handle = "cielo"
    payment_method.handle.should eq("cielo")
  end

  it "has active" do
    payment_method.active = true
    payment_method.should be_active
  end
end
