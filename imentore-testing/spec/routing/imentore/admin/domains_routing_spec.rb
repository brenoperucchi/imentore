require "spec_helper"

describe "Admin::Domains routes" do
  before { @routes = Imentore::Core::Engine.routes }

	it "GET /admin/domains to admin/domains#new" do
		get("/admin/domains").should route_to("imentore/admin/domains#index")
	end

	it "POST /admin/domains to admin/domains#create" do
		post("/admin/domains").should route_to("imentore/admin/domains#create")
	end

	it "DELETE /admin/domains/1 to admin/domains#destroy" do
		delete("/admin/domains/1").should route_to("imentore/admin/domains#destroy", id: "1")
	end
end