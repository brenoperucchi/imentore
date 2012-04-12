require "spec_helper"

describe Imentore::Domain do
  let(:domain) { subject }

  it { should belong_to :store }

  it "has emails" do
    domain.emails = { breno: 123 }
    domain.emails.should eq({ breno: 123 })
  end
end
