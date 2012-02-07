require 'spec_helper'

describe "Dashboard routing" do
  it "routes /admin to dashboard#index" do
    { get: '/admin' }.should route_to(controller: 'imentore/admin/dashboard', action: 'index')
  end
end