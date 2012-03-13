require "spec_helper"

describe "Dashboard routes" do
  before { @routes = Imentore::Core::Engine.routes }

  it "/admin to dashboard#index" do
    get("/admin").should route_to("imentore/admin/dashboard#index")
  end
end