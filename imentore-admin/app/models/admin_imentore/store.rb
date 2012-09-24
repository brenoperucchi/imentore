#!/bin/env ruby
# encoding: utf-8

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

    def self.install_stores
        Old::Store.active[0..0].each do |store|
          new_store = Imentore::Store.new
          new_store.name = fix_utf8(store.name)
          new_store.brand = fix_utf8(store.brand)
          new_store.brand ||= fix_utf8(store.name)
          new_store.url = store.url
          new_store.irs_id = store.irs_id
          new_store.plan_id = store.plan_id
          new_store.user_agent_id = store.user_agent_id
          new_store.state = store.state
          new_store.created_at = store.created_at
          new_store.disabled_at = store.disabled_at
          new_store.actived_at = store.actived_at
          new_store.config = Imentore::Settings.new
          unless new_store.save
            binding.pry
          end
          new_store.create_defaults

          store.customers.each do |customer|
            unless customer.encrypted_password.nil?
              new_customer = new_store.customers.new 
              new_customer.name = fix_utf8(customer.name)
              new_customer.brand = fix_utf8(customer.name) if customer.type == "Person"
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
              unless user.save
                binding.pry
              end
            end
          end
          store.employees.each do |employee|
            unless employee.encrypted_password.nil?
              new_employee = new_store.employees.new 
              new_employee.name = fix_utf8(employee.name)
              new_employee.brand = fix_utf8(employee.name) if employee.type == "Person"
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
                binding.pry
              end
              user = new_employee.build_user(email: employee.email, encrypted_password: employee.encrypted_password, 
                                       sign_in_count: employee.sign_in_count, current_sign_in_at: employee.current_sign_in_at,
                                       last_sign_in_ip: employee.last_sign_in_ip, confirmed_at: employee.confirmed_at, 
                                       created_at: employee.created_at, store_id: new_store.id, password_required: false,
                                       password_salt: employee.password_salt)
              unless user.save
                binding.pry
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
            binding.pry
          end


          store.products.not_deleted.each do |product|
            new_product = Imentore::Product.new
            new_product.store_id = new_store.id
            new_product.name = fix_utf8(product.name)
            new_product.description = fix_utf8(product.description)
            new_product.active = product.sellable
            new_product.handle = ActiveSupport::Inflector.transliterate(product.name).to_underscore
            new_product.store_id = new_store.id
            new_product.save
            unless new_product.save
              binding.pry
            end
            product.variants.each do |variant|
              default_option = new_product.options.create(name: variant.name, handle: ActiveSupport::Inflector.transliterate(variant.name).to_underscore)
              new_variant = new_product.variants.new
              new_variant.height = variant.height
              new_variant.width = variant.width
              new_variant.quantity = variant.units.size
              new_variant.price = variant.value
              new_variant.save
              @new_variant = new_variant
              @new_variant.options.create(option_type: default_option, value: "padrão")
            end
            product.images.each do |image|
              new_image = @new_variant.images.new
              new_image.remote_picture_url = "http://lojateste2.imentore.com.br" + image.picture.url 
              new_image.save
            end
          end
        end
    end

    end
end