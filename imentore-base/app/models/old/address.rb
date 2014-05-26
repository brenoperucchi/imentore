module Old
  class Address < ActiveRecord::Base

    attr_accessor :back_referer_uri
    belongs_to :addressable, :polymorphic => true

    validates_presence_of :title, :street1, :city, :state, :zip, :country, :phone
    

    # default_value_for :title, I18n.t(:main)

    #validates_uniqueness_of :title, :scope => [:addressable_id, :addressable_type]

    def to_s
      "#{street1}, #{city}, #{state}, #{zip}, #{country}"
    end

    def self.table_name
      "addresses"
    end

    self.abstract_class = true
      establish_connection(
       :adapter  => 'mysql2',
       :database => 'go2b_production',
       :host     => 'localhost',
       :username => 'imentoreapp',
       :password => 'app0p..za'
    )
  end
end