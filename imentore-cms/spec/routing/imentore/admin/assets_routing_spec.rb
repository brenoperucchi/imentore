require "spec_helper"

describe "Admin::Assets routes" do
  before { @routes = Imentore::Core::Engine.routes }

  it "GET /admin/themes/:id/assets/new to admin/assets#new" do
    get("/admin/themes/1/assets/new").should route_to("imentore/admin/assets#index")
  end

  it "GET /admin/themes/:id/templates/new to admin/templates#new" do
    get("/admin/themes/1/templates/new").should route_to("imentore/admin/templates#new", theme_id: "1")
  end

  it "POST /admin/themes/:id/assets to admin/assets#create" do
    POST("/admin/themes/1/assets").should route_to("imentore/admin/themes#index", theme_id: "1")
  end

  it "PUT /admin/themes/:id/assets to admin/assets#update" do
    PUT("/admin/themes/1/assets").should route_to("imentore/admin/themes#index", theme_id: "1")
  end

  it "DELETE /admin/themes/:id/assets/1 to admin/assets#destroy" do
    DELETE("/admin/themes/1/assets/1").should route_to("imentore/admin/themes#index", theme_id: "1")
  end

end