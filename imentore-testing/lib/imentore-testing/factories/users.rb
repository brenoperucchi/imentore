FactoryGirl.define do
  factory :myshop_owner_user, class: Imentore::User do
    email 'owner@myshop.imentore.dev'
    password '123123'
    password_confirmation '123123'
  end
end