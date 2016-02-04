FactoryGirl.define do
  setting = Imentore::Settings.new
  setting.email_contact = 'john@doe.com'
  factory :store_test, class: Imentore::Store do
    brand 'brand'
    url 'loja'
    config setting
    factory :config, class: 'Imentore::Setting' do

    end
    association :owner, factory: 'myshop_owner', strategy: :build

    after(:create) do |store|
      store.create_defaults
      # FactoryGirl.create(:mug, store: store)
      # FactoryGirl.create(:cielo, store: store)
      # FactoryGirl.create(:fedex, store: store)
    end
  end
end
