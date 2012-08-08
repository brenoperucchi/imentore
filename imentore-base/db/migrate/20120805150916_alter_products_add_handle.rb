class AlterProductsAddHandle < ActiveRecord::Migration
  def change
    add_column :imentore_products, :handle, :string
  end

end
