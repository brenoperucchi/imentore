#!/bin/env ruby
# encoding: utf-8
## http://jalada.co.uk/2011/12/07/solving-latin1-and-utf8-errors-for-good-in-ruby.html
module AdminImentore
  class Store

    def self.fix_utf8(text)      
      text.encode('cp1252',
                  :fallback => {
                    "\u0081" => "\x81".force_encoding("cp1252"),
                    "\u008D" => "\x8D".force_encoding("cp1252"),
                    "\u008F" => "\x8F".force_encoding("cp1252"),
                    "\u0090" => "\x90".force_encoding("cp1252"),
                    "\u009D" => "\x9D".force_encoding("cp1252")
                  })
          .force_encoding("utf-8")
    end

    def self.install_store(store)
      install(store)
    end

    def self.install_stores
      Old::Store.active.each do |old_store|
        store = Old::Store.find_by_url(old_store.url) 
        next if store.nil?
        install(store)
      end
    end


    def self.products_reinstall
      Imentore::Store.active.each do |new_store|
        next if store.nil?
        products_reinstall_store(new_store)
      end
    end

    def self.products_reinstall_store(new_store)
      store = new_store.old_store
      return if store.nil?
      new_store.update_attribute(:old_store_id, store.id)
      new_store.products.destroy_all
      store.products.not_deleted.sellable.each do |product|
        new_product = new_store.products.new
        new_product.name = product.name
        new_product.description = product.description
        new_product.active = product.sellable
        new_product.handle = ActiveSupport::Inflector.transliterate(product.name).to_underscore
        new_product.created_at = product.created_at
        new_product.save
        unless new_product.save
          new_product.handle = new_product.handle + "_#{rand(100)}"
          unless new_product.save
            new_product.handle = new_product.handle + "_#{rand(1000)}"
            unless new_product.save
              new_product.handle = new_product.handle[0..10]
              new_product.save
            end
          end
        end

        product.categories.each do |category|
          c = new_store.categories.find_by_name(category.title)
          unless c.nil?
            c = c.categories_products.new
            c.product_id = new_product.id
            c.save
          end
        end

        default_option = new_product.options.create(name: I18n.t(:variant), handle:'variant')

        product.variants.each do |variant|
          new_variant = new_product.variants.new
          new_variant.height = variant.height
          new_variant.width = variant.width
          new_variant.quantity = variant.units.size
          new_variant.price = variant.value
          unless new_variant.save
            binding.pry
          end
          new_variant.options.create(option_type: default_option, value: ActiveSupport::Inflector.transliterate(variant.name).to_underscore)
        end
        # unless Rails.env = "development"
          product.images.each do |image|
            begin
              new_image = new_product.variants.first.images.new
              new_image.remote_picture_url = "http://lojateste2.imentore.com.br" + image.picture.url 
              new_image.save
            rescue 
              next
            end
          end
      end
    end      

    def self.orders_install(store, old_store)
        old_store.orders.not_deleted.each do |old_order|
          new_order = store.orders.new
          old_order.items.each do |old_item|
            product = store.products.find_by_name(old_item.product.name)
            next if product.nil?
            variant = product.variants.first
            variant.price = old_item.price
            new_order.items << Imentore::LineItem.new(product, variant, old_item.quantity)
          end
          unless old_order.invoices.blank?
            # begin
              old_invoice = old_order.invoices.last
              payment_method = (old_invoice.payment.try(:method_type) == "pg") ? store.payment_methods.find_by_handle("pag_seguro") : store.payment_methods.last
            # rescue Exception => msg
              # binding.pry
            # end
            amount_order = new_order.products_amount
            amount_order += old_order.shipments.try(:last).try(:price) unless old_order.shipments.blank?
            new_order.build_invoice(amount: amount_order , payment_method: payment_method)

          end
          unless old_order.shipments.blank?
            # begin
              if old_order.shipments.last.shipping.code.nil?
                delivery_method = store.delivery_methods.find_by_handle("custom")
              else
                delivery_method = store.delivery_methods.find_by_handle(old_order.shipments.last.shipping.code.to_underscore)
              end
            # rescue Exception => msg
              # binding.pry
            # end
            old_address = old_order.shipments.last.address
            address = Imentore::Address.new(name: old_address.title, street: old_address.street1 + old_address.street2, city: old_address.city, state: old_address.state, country: old_address.country, phone: old_address.phone, zip_code: old_address.zip)
            new_order.build_delivery(address: address, delivery_method: delivery_method, amount: old_order.shipments.last.price) unless old_order.invoices.blank?
            new_order.shipping_address = address
            new_order.billing_address = address
          end
          # unless old_order.invoices.blank?# or old_order.invoices.blank?
          # end
        begin
          new_order.customer_name = old_order.user.name
          new_order.customer_email = old_order.user.email
          new_order.save  
          new_order.update_attribute(:created_at, old_order.created_at)
          new_order.invoice.confirm if old_order.invoices.try(:last).try(:state) ==  "paid"
          new_order.delivery.sent unless old_order.shipping_state != "shipped" or (old_order.shipments.blank? or old_order.invoices.blank?)
        rescue
          binding.pry
        end
          case old_order.state
            when "checkout", "placed"
              new_order.update_attribute(:status, "placed")
            when "closed", "canceled"
              new_order.update_attribute(:status, "finished")
          end 
          # binding.pry
        end
      
    end

    def self.install_customers_employees(store, new_store)
      return if store.nil?
      store.customers.each do |customer|
        unless customer.encrypted_password.nil?
          new_customer = new_store.customers.new 
          new_customer.name = customer.name
          new_customer.brand = customer.name if customer.type == "Person"
          new_customer.irs_id = customer.irs_id 
          new_customer.national_id = customer.national_id
          new_customer.birthdate = customer.birthdate
          new_customer.gender = customer.gender
          new_customer.person_type = customer.type == 'Person' ? 'person' : 'company'
          new_customer.store_id = new_store.id
          new_customer.active = customer.active
          new_customer.created_at = customer.created_at
          new_customer.save
          user = new_customer.build_user(email: customer.email, encrypted_password: customer.encrypted_password, 
                                   sign_in_count: customer.sign_in_count, current_sign_in_at: customer.current_sign_in_at,
                                   last_sign_in_ip: customer.last_sign_in_ip, confirmed_at: customer.confirmed_at, 
                                   created_at: customer.created_at, store_id: new_store.id, password_required: false, 
                                   password_salt: customer.password_salt)
          new_customer.destroy unless user.save(validate: false) 
        end
      end

      employee = store.users.find_by_role('admin')
      new_employee = new_store.employees.new 
      new_employee.name = employee.name
      new_employee.brand = employee.name if employee.type == "Person"
      new_employee.irs_id = employee.irs_id 
      new_employee.national_id = employee.national_id
      new_employee.birthdate = employee.birthdate
      new_employee.gender = employee.gender
      new_employee.person_type = employee.type == 'Person' ? 'person' : 'company'
      new_employee.department = "owner"
      new_employee.store_id = new_store.id
      new_employee.active = employee.active
      new_employee.created_at = employee.created_at
      unless new_employee.save
        new_employee.destroy
      end
      user = new_employee.build_user(email: employee.email, encrypted_password: employee.encrypted_password, 
                               sign_in_count: employee.sign_in_count, current_sign_in_at: employee.current_sign_in_at,
                               last_sign_in_ip: employee.last_sign_in_ip, confirmed_at: employee.confirmed_at, 
                               created_at: employee.created_at, store_id: new_store.id, password_required: false,
                               password_salt: employee.password_salt)
      new_employee.destroy unless user.save(validate: false)
    end

    def self.category_create(new_category, category, store)
      category.children.each do |children|
        category_1 = new_category.children.new(name: children.title, handle: ActiveSupport::Inflector.transliterate(children.title).to_underscore, store_id: store.id)
        unless category_1.save
          category_1.handle = category_1.handle + "_#{rand(1000)}"
          unless category_1.save
            binding.pry
          end
        end
        if children.has_children?
          category_create(category_1, children, store)
        end
      end
    end

    def self.install(store)
      new_store = Imentore::Store.new
      new_store.name = store.name 
      new_store.brand = store.brand unless store.brand.blank?
      new_store.brand ||= store.name 
      new_store.url = store.url
      new_store.irs_id = store.irs_id
      new_store.plan_id = store.plan_id
      new_store.user_agent_id = store.user_agent_id
      new_store.state = store.state
      new_store.created_at = store.created_at
      new_store.disabled_at = store.disabled_at
      new_store.actived_at = store.actived_at
      new_store.config = Imentore::Settings.new
      new_store.old_store_id = store.id
      unless new_store.save
        puts "----------------------"
        puts store.id
        puts store.errors.full_messages
        binding.pry
        puts "----------------------"
        return 
      end

      store.categories.roots.each do |category|
        new_category = new_store.categories.new(name: category.title, handle: ActiveSupport::Inflector.transliterate(category.title).to_underscore)
        unless new_category.save
          new_category.handle = new_category.handle + "_#{rand(1000)}"
          new_category.store_id = new_store.id
          unless new_category.save
            binding.pry
          end
        end
        category_create(new_category, category, new_store)
      end

      new_store.create_defaults

      store.pages.each do |page|
        unless page.path == "home"
          new_page = new_store.pages.new
          new_page.name = page.path
          new_page.handle = page.path
          new_page.body = page.body
          new_page.html = page.html
          new_page.active = page.active
          new_page.created_at = page.created_at
          new_page.save
        end
      end


      store.notices.each do |page|
        new_page = new_store.notices.new
        new_page.active = page.active
        new_page.name = page.title
        new_page.handle = ActiveSupport::Inflector.transliterate(page.title).to_underscore
        new_page.body = page.description
        new_page.created_at = page.created_at
      end

      install_customers_employees(store, new_store)

      store.employees.each do |employee|
        unless employee.encrypted_password.nil?
          new_employee = new_store.employees.new 
          new_employee.name = employee.name
          new_employee.brand = employee.name if employee.type == "Person"
          new_employee.irs_id = employee.irs_id 
          new_employee.national_id = employee.national_id
          new_employee.birthdate = employee.birthdate
          new_employee.gender = employee.gender
          new_employee.person_type = employee.type == 'Person' ? 'person' : 'company'
          new_employee.department = "owner"
          new_employee.store_id = new_store.id
          new_employee.active = employee.active
          new_employee.created_at = employee.created_at
          unless new_employee.save
            new_employee.destroy
          end
          user = new_employee.build_user(email: employee.email, encrypted_password: employee.encrypted_password, 
                                   sign_in_count: employee.sign_in_count, current_sign_in_at: employee.current_sign_in_at,
                                   last_sign_in_ip: employee.last_sign_in_ip, confirmed_at: employee.confirmed_at, 
                                   created_at: employee.created_at, store_id: new_store.id, password_required: false,
                                   password_salt: employee.password_salt)
          unless user.save
            new_employee.destroy
          end
        end
      end

      employee = Person.find(3)
      new_employee = new_store.employees.new 
      new_employee.name = employee.name 
      new_employee.brand = employee.name if employee.type == "Person"
      new_employee.irs_id = employee.irs_id 
      new_employee.national_id = employee.national_id
      new_employee.birthdate = employee.birthdate
      new_employee.gender = employee.gender
      new_employee.person_type = employee.type == 'Person' ? 'person' : 'company'
      new_employee.department = "owner"
      new_employee.store_id = new_store.id
      new_employee.active = employee.active
      new_employee.created_at = employee.created_at
      new_employee.save
      user = new_employee.build_user(email: employee.email, encrypted_password: employee.encrypted_password, 
                               sign_in_count: employee.sign_in_count, current_sign_in_at: employee.current_sign_in_at,
                               last_sign_in_ip: employee.last_sign_in_ip, confirmed_at: employee.confirmed_at, 
                               created_at: employee.created_at, store_id: new_store.id, password_required: false,
                               password_salt: employee.password_salt)
      unless user.save
        new_employee.destroy
      end


      store.products.not_deleted.each do |product|
        new_product = Imentore::Product.new
        new_product.store_id = new_store.id
        new_product.name = product.name
        new_product.description = product.description
        new_product.active = product.sellable
        new_product.handle = ActiveSupport::Inflector.transliterate(product.name).to_underscore
        new_product.store_id = new_store.id
        new_product.save
        unless new_product.save
          new_product.handle = new_product.handle + "_#{rand(1000)}"
          unless new_product.save
            new_product.handle = new_product.handle + "_#{rand(1000)}"
            new_product.save
            binding.pry
          end
        end

        product.categories.each do |category|
          c = new_store.categories.find_by_name(category.title)
          unless c.nil?
            c = c.categories_products.new
            c.product_id = new_product.id
            c.save
          end
        end

        default_option = new_product.options.create(name: I18n.t(:variant), handle:'variant')

        product.variants.each do |variant|
          new_variant = new_product.variants.new
          new_variant.height = variant.height
          new_variant.width = variant.width
          new_variant.quantity = variant.units.size
          new_variant.price = variant.value_deal.present? ? variant.value_deal : variant.value
          unless new_variant.save
            binding.pry
          end
          new_variant.options.create(option_type: default_option, value: ActiveSupport::Inflector.transliterate(variant.name).to_underscore)
        end

        unless Rails.env == "development"
          product.images.each do |image|
            # begin
              new_image = new_product.variants.first.images.new
              new_image.remote_picture_url = "http://lojateste2.imentore.com.br" + image.picture.url 
              new_image.save
            # rescue OpenURI::HTTPError
              # next
            # end
          end
        end        

      end
    end
  end
end