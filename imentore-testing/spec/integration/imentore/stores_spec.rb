require_relative "../../../lib/imentore-testing/rails_helper"

describe "Stores" do
  describe "#new" do
    it "shows the form to create a new store" do
      visit page_site_path('register')
      expect(page).to have_field('store_url')
      expect(page).to have_field('store_owner_attributes_user_attributes_email')
      expect(page).to have_field('store_owner_attributes_user_attributes_password')
      expect(page).to have_button('Crie sua Conta')
    end
  end
end

describe "Show" do
  context "#confirm" do
    let(:store) { FactoryGirl.create(:store_test) }
   
    it "renders show when store exists" do
      get "http://loja.imentore.dev"
      expect(response.status).to equal(200)
      expect(response).to render_template("show")
    end

    it "gives 404 when store not found" do
      get "http://oops.imentore.dev"
      expect(response.status).to equal(200)
      expect(response).to render_template('imentore/site/show')
    end

  end
end