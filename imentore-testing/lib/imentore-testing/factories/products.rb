FactoryGirl.define do
  factory :mug, class: Imentore::Product do
    name        "Product"
    description "Goooorgeous NY mug!"

    after(:create) do |product|
      # product.options.new(name: "Model")
      FactoryGirl.create(:default_mug, product: product)
    end
  end
end

FactoryGirl.define do
  factory :default_mug, class: Imentore::ProductVariant do
    price       15
    quantity    50
    deliverable true

    after(:create) do |variant|
      option_type = variant.product.options.first
      variant.options.new(value: "default", option_type: option_type)
    end
  end
end
