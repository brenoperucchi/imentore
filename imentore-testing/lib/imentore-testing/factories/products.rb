FactoryGirl.define do
  factory :mug, class: Imentore::Product do
    name        "I <3 NY mug"
    description "Goooorgeous NY mug!"

    after_create do |product|
      product.options.create(name: "Model")
      FactoryGirl.create(:default_mug, product: product)
    end
  end
end

FactoryGirl.define do
  factory :default_mug, class: Imentore::ProductVariant do
    price     15
    quantity  50

    after_create do |variant|
      option_type = variant.product.options.first
      variant.options.create(value: "default", option_type: option_type)
    end
  end
end
