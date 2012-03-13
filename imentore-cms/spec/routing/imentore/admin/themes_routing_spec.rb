require "spec_helper"

describe "Themes routes" do
  before { @routes = Imentore::Core::Engine.routes }

  it "/admin/themes to themes#index" do
    get("/admin/themes").should route_to("imentore/admin/themes#index")
  end
end