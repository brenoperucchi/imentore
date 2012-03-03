require 'spec_helper'

describe "Admin::Domains routes" do
	it "/admin/domains to admin/domains#new" do
		{ get: '/admin/domains'}.should route_to(:controller => 'imentore/admin/domains', action: 'index' )
	end

	it "/admin/domains to admin/domains#create" do
		{ post: '/admin/domains'}.should route_to(:controller => 'imentore/admin/domains', action: 'create' )
	end
end