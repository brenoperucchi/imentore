module Imentore
  class OrderDrop < Liquid::Drop
    include Imentore::Core::Engine.routes.url_helpers

    def before_method(method)
      self.respond_to?(method) ? send(method) : @object.send(method)
    end

    def initialize(object)
      @object = object
    end

    def created_at
      I18n.l(@object.created_at, :format=>:short2)
    end

    def invoice
      @invoice = ObjectDrop.new(@object.invoice)
    end

    def invoice_method
      @invoice_method = ObjectDrop.new(@object.invoice_method)
    end

    def delivery_method
      @invoice_method = ObjectDrop.new(@object.delivery_method)
    end

    def billing_address
      @billing_address = ObjectDrop.new(@object.billing_address)
    end

    def shipping_address
      @shipping_address = ObjectDrop.new(@object.shipping_address)
    end

    def products_amount
      number_with_price(@object.products_amount)
    end

    def delivery_amount
      number_with_price(@object.delivery_amount)
    end

    def coupons_amount
      number_with_price(@object.coupons_amount)
    end

    def total_amount
      number_with_price(@object.total_amount)
    end

  end
end