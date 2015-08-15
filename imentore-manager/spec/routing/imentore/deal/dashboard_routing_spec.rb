require "spec_helper"

describe "Deal::dashboard routes" do
  before { @routes = Imentore::Core::Engine.routes }

  it "GET /deal to /deal/dealers#index" do
    get("/deal").should route_to("imentore/deal/dealers#index")
  end


end