class CreateCouponsOrder < ActiveRecord::Migration
  def up
      create_table(:imentore_coupons_orders) do |t|
        t.string :email
        t.references :coupon, :cart, :order, :user, :store
      end
    end

    def down
      drop_table(:imentore_coupons_orders)
    end
end
