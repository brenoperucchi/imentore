FactoryGirl.define do
  factory :myshop, class: Imentore::Store do
    brand 'MyShop'
    url 'myshop'
    association :owner, factory: 'myshop_owner', method: :build
  end
end