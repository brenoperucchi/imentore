module Imentore
  class Settings
    module Virtual
      def self.attributes
        [:theme, :authenticate_to_buy, :store_zip_code, :order_asset, :email_contact, :site]
      end

      attr_accessor *attributes

      def self.included(base)
        base.register_attributes *attributes
        base.class_eval do
          validates :theme, presence: true
        end
      end

      def theme
        @theme || :default
      end

      def authenticate_to_buy
        @authenticate_to_buy.nil? ? true : @authenticate_to_buy
      end

      def authenticate_to_buy=(value)
        @authenticate_to_buy = (value == "1")
      end

      def order_asset=(value)
        @order_asset = (value == "1")
      end

      def order_asset
        @order_asset || false
      end

    end
  end
end