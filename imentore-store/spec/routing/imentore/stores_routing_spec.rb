require 'spec_helper'

describe "Stores" do
  it "routes /stores/new to #new" do
    { get: '/stores/new' }.should route_to(controller: 'imentore/stores', action: 'new')
  end

  it "routes POST /stores to #create" do
    { post: '/stores' }.should route_to(controller: 'imentore/stores', action: 'create')
  end
end