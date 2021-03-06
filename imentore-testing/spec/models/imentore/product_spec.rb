require "spec_helper"

describe Imentore::Product do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  # it { should validate_presence_of(:permalink) }
  it { should have_many(:options) }
  it { should belong_to(:store) }
  it { should have_many(:variants) }
  it { should respond_to(:variants_attributes=) }
end
