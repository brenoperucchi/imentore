require "spec_helper"

describe "Cart routes" do
  before { @routes = Imentore::Core::Engine.routes }

  it "/cart to cart#show" do
    get("/cart").should route_to("imentore/carts#show")
  end

  it "POST /cart to cart#create" do
    post("/cart").should route_to("imentore/carts#create")
  end
end
