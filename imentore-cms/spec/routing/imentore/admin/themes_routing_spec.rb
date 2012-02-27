require "spec_helper"

describe "Themes routing" do
  it "routes /admin/themes to themes#index" do
    { get: '/admin/themes' }.should route_to(controller: 'imentore/admin/themes', action: 'index')
  end
end