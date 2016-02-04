require "spec_helper"

describe Imentore::DeliveryMethod do
  it "has store_id" do
    subject.store_id = 123
    subject.store_id.should eq(123)
  end

  it "has name" do
    subject.name = "Fedex"
    subject.name.should eq("Fedex")
  end

  it "has handle" do
    subject.handle = "fedex"
    subject.handle.should eq("fedex")
  end

  it "has options" do
    subject.options = { a: 1 }
    subject.options.should eq({ a: 1 })
  end
end
