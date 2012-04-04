FactoryGirl.define do
  factory :myshop, class: Imentore::Store do
    brand 'MyShop'
    url 'myshop'
    association :owner, factory: 'myshop_owner', strategy: :build

    after_create do |store|
      FactoryGirl.create(:green_theme)
      FactoryGirl.create(:mug, store: store)
    end
  end
end
