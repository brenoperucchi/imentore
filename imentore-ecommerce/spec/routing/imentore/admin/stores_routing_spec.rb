require 'spec_helper'

describe "Admin::Stores routes" do
  before { @routes = Imentore::Core::Engine.routes }

  it "/admin/store/edit to admin/stores#edit" do
    get("/admin/store/edit").should route_to("imentore/admin/stores#edit")
  end

  it "PUT /admin/store to admin/store#update" do
    put("/admin/store").should route_to("imentore/admin/stores#update")
  end
end