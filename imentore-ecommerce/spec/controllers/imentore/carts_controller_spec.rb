require "spec_helper"

describe Imentore::CartsController do
  before do
    request.host = "myshop.imentore.dev"
  end

  let(:store)   { FactoryGirl.create(:myshop) }
  let(:product) { store.products.first }
  let(:variant) { product.variants.first }
  let(:cart)    { subject.current_cart }

  def item_params(params = {})
    { product_id: product.id, variant_id: variant.id, quantity: 1 }.merge(params)
  end

  describe "add item" do
    it "adds valid product, valid and quantity" do
      post(:create, item: item_params)

      cart.should have(1).item
    end

    it "does not add item if quantity less or equal than zero" do
      post(:create, item: item_params(quantity: 0))
      cart.should be_empty
    end
  end
end
