FactoryGirl.define do
  factory :green_theme, class: Imentore::Theme do
    name    "green"
    default true
    # after_create do |theme, factory_definition|
    #   Factory.create(:green_layout, theme: theme)
    # end
  end

  factory :green_layout, class: Imentore::Template do
    path  "layouts/green"
    body  "<div> <%= debug flash %> </div> Default theme: green <br/> {{ content_for_layout }}"
  end
end