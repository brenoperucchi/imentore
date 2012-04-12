require "spec_helper"

describe Imentore::CartsController do
  let(:store)   { FactoryGirl.create(:myshop) }
  let(:product) { store.products.first }
  let(:variant) { product.variants.first }
  let(:cart)    { Imentore::Cart.new }

  before do
    subject.stub(check_store: true, current_store: store, current_cart: cart)
  end

  def item_params(params = {})
    { product_id: product.id, variant_id: variant.id, quantity: 1 }.merge(params)
  end

  describe "add item" do
    it "adds valid product, valid and quantity" do
      post(:create, item: item_params)

      cart.items.should have(1).item
    end

    it "does not add item if quantity less or equal than zero" do
      post(:create, item: item_params(quantity: 0))

      cart.should be_empty
    end
  end
end
