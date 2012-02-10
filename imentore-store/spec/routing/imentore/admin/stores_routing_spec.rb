require 'spec_helper'

describe "Admin::Stores routes" do
  it "/admin/store/edit to admin/stores#edit" do
    { get: '/admin/store/edit' }.should route_to(controller: 'imentore/admin/stores', action: 'edit')
  end

  it "PUT /admin/store to admin/store#update" do
    { put: '/admin/store' }.should route_to(controller: 'imentore/admin/stores', action: 'update')
  end
end