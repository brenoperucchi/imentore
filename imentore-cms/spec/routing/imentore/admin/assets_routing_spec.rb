require "spec_helper"

describe "Admin::Assets routes" do
  before { @routes = Imentore::Core::Engine.routes }

  it "GET /admin/themes/:id/assets/new to admin/assets#new" do
    get("/admin/themes/1/assets/new").should route_to("imentore/admin/assets#new", theme_id: "1")
  end

  it "POST /admin/themes/:id/assets to admin/assets#create" do
    post("/admin/themes/1/assets").should route_to("imentore/admin/assets#create", theme_id: "1")
  end

  it "PUT /admin/themes/:id/assets/:id to admin/assets#update" do
    put("/admin/themes/1/assets/1").should route_to("imentore/admin/assets#update", theme_id: "1", id: "1")
  end

  it "DELETE /admin/themes/:id/assets/1 to admin/assets#destroy" do
    delete("/admin/themes/1/assets/1").should route_to("imentore/admin/assets#destroy", theme_id: "1", id: "1")
  end
end
