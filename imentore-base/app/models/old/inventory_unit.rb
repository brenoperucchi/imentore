module Old
  class InventoryUnit < ActiveRecord::Base

    def self.table_name
      "inventory_units"
    end
    
    self.abstract_class = true
     establish_connection(
     :adapter  => 'mysql2',
     :database => 'go2b_production',
     :host     => 'host.imentore.com.br',
     :username => 'imentoreapp',
     :password => 'app0p..za'
     )
          
    belongs_to :variant,
      :class_name => "ProductVariant"

    belongs_to :item,
      :class_name => "LineItem"


    validates_presence_of :variant_id

    scope :in_stock, :conditions => { :state => 'stock' }
    scope :reserved, :conditions => { :state => 'reserved' }
    scope :shipped, :conditions => { :state => 'shipped' }
    scope :backorder, :conditions => { :state => 'backorder' }, :order => "created_at ASC"

    state_machine :initial => :stock do
      after_transition :on => :ship, :do => lambda { |iu| Log.logger(iu, I18n.t(:inventory_unit_shipped, :order => iu.item.order_id)) }
      before_transition :on => :return, :do => lambda { |iu| Log.logger(iu, I18n.t(:inventory_unit_returned, :order => iu.item.order_id)) }
      before_transition :on => [:defect, :return], :do => lambda { |iu| iu.item_id = nil }
      event :reserve do
        transition [:stock, :backorder] => :reserved
      end

      event :ship do
        transition [:reserved, :returned] => :shipped
      end

      event :defect do
        transition :shipped => :broken
      end

      event :return do
        transition :shipped => :returned
      end

      event :to_stock do
        transition all => :stock
      end
    end

    def self.reserve(quantity, variant, item)
      units = in_stock.find(:all, :conditions => {:variant_id => variant.id}, :limit => quantity)
      units.each do |iu|
        iu.item = item
        iu.reserve
      end
      backorders = quantity - units.size
      backorders.times do
        item.units.create(:variant_id => variant.id, :state => "backorder")
      end
    end

    def self.delete_or_nullify_for_item(item_id)
      units = find(:all, :conditions => {:item_id => item_id})
      units.each do |unit|
        if unit.backorder?
          unit.destroy
        elsif unit.reserved?
          unit.item_id = nil
          unit.to_stock
        end
      end
    end

  end
end