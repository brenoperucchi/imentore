require "spec_helper"

describe Imentore::OptionValue do
  it { should belong_to(:option_type) }
  it { should validate_presence_of(:option_type_id) }
  it { should validate_presence_of(:product_variant_id) }
  it { should validate_presence_of(:value) }
end
