require "spec_helper"

describe Imentore::ProductVariant do
  it { should belong_to(:product) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:quantity) }
  # it { should validate_presence_of(:product) }
  it { should have_many(:options) }
end
