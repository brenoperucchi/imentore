require "spec_helper"

describe Imentore::Address do
  it { should belong_to(:addressable) }

  it "does not require any attribute by default" do
    subject.valid?.should be_true
  end

  context "when validate is true" do
    before { subject.validate = true }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:zip_code) }
    it { should validate_presence_of(:phone) }
  end
end