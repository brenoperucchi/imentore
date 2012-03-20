require "spec_helper"

describe Imentore::OptionType do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:handle) }
  it { should validate_presence_of(:product_id) }
  it {
    subject.class.create(name: "Foo", handle: "foo", product_id: 1)
    should validate_uniqueness_of(:handle).scoped_to(:product_id)
  }
  it { should allow_value("word").for(:handle) }
  it { should allow_value("two-words").for(:handle) }
  it { should_not allow_value("123").for(:handle) }
  it { should_not allow_value("#%@*!").for(:handle) }
end
