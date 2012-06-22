module Imentore
  module Admin
    class CouponsController < BaseController
      inherit_resources
      # actions :index, :new, :create, :edit, :update

      def new
        @coupon = build_resource
        code = SecureRandom.base64(5).gsub("/","_").gsub(/=+$/,"").upcase
        while not current_store.coupons.find_by_code(@code).nil?
          code = SecureRandom.base64(5).gsub("/","_").gsub(/=+$/,"").upcase
        end
        @coupon.code = code
      end

      def create
        create! { admin_coupons_path}
      end

      def update
        update! { admin_coupons_path}
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
