require "spec_helper"

describe Imentore::Theme do
  it { should validate_presence_of(:name) }
  it { should belong_to(:store) }
  it { should have_many(:templates) }
  it { should have_many(:assets) }
end