class AddPriceDealToVariant < ActiveRecord::Migration
  def change
    add_column :imentore_product_variants, :price_deal, :decimal, :precision => 10, :scale => 2
  end
end
