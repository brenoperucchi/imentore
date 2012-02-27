FactoryGirl.define do
  factory :myshop_owner, class: Imentore::Employee do
    name 'MyShop Owner'
    person_type 'person'
    department 'owner'
    association :user, factory: 'myshop_owner_user', strategy: :build
  end
end