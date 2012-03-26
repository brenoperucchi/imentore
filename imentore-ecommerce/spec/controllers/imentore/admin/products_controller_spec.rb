require "spec_helper"

describe Imentore::Admin::ProductsController do
  before do
    @store = Factory.create(:myshop)
    subject.stub(check_store: true, authorize_admin: true, current_store: @store)
  end

  context "when creating product" do
    it "creates a variant, default option type and value" do
      post(:create, product: { name: "Mug", description: "Mug",
        variants_attributes: { "0" => { price: "10", quantity: "50" } }
      })

      product = @store.products.first

      product.variants.should have(1).item
      product.options.should have(1).item

      variant = product.variants.first
      variant.options.should have(1).item

      option_type = product.options.first
      option_value = variant.options.first

      option_type.name.should eq("Model")
      option_value.value.should eq("default")
    end
  end
end
