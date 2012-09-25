#!/bin/env ruby
# encoding: utf-8
module Old
  class Product < ActiveRecord::Base

    def self.table_name
      "products"
    end

    scope :not_deleted, where(deleted_at: nil)

    has_many :categories_products
    has_many :categories, :through => :categories_products, :source => :category

    has_many :variants,
      :class_name => Old::ProductVariant,
      :dependent => :destroy

    has_many :images,
      :as => :imageable,
      :dependent => :destroy,
      :finder_sql => proc {" SELECT images.* FROM images  WHERE images.imageable_id = #{self.id} AND images.imageable_type = 'Product' "}

      #:finder_sql => ' SELECT users.* FROM users STRAIGHT_JOIN
      # (`products`, `categories_products`) WHERE (`users`.store_id = #{store_id} AND `categories_products`.category_id =
      # 3 and `users`.role = "supplier" and `products`.id = `categories_products`.product_id) GROUP BY email',

    has_many :units,
      :through => :variants,
      :source => :units


    self.abstract_class = true
     establish_connection(
     :adapter  => 'mysql2',
     :database => 'imentore_go2b',
     :host     => 'host.imentore.com.br',
     :username => 'go2b',
     :password => '123123'
     )
  end
end