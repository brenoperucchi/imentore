require "spec_helper"

describe "Admin::Themes::Templates routes" do
  it "/admin/themes/:id/templates/new to admin/templates#new" do
    { get: "/admin/themes/1/templates/new" }.should route_to(controller: "imentore/admin/templates", action: "new", theme_id: "1")
  end
end