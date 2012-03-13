require "spec_helper"

describe "Themes templates routes" do
  before { @routes = Imentore::Core::Engine.routes }

  it "/admin/themes/:id/templates/new to admin/templates#new" do
    get("/admin/themes/1/templates/new").should route_to("imentore/admin/templates#new", theme_id: "1")
  end
end