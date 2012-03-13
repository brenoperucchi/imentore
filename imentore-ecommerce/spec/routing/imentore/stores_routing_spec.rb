require 'spec_helper'

describe "Stores routes" do
  before { @routes = Imentore::Core::Engine.routes }

  it "/stores/new to #new" do
    get("/stores/new").should route_to("imentore/stores#new")
  end

  it "POST /stores to #create" do
    post("/stores").should route_to("imentore/stores#create")
  end
end