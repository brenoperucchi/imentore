require "spec_helper"

describe "Products routes" do
  before { @routes = Imentore::Core::Engine.routes }

  it "/products/:id to #show" do
    get("/products/1").should route_to("imentore/products#show", id: "1")
  end
end
