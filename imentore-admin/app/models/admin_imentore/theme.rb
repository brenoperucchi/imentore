module AdminImentore
  class Theme < ActiveRecord::Base

    def self.table_name
      "admin_imentore_themes"
    end

    has_many :templates, :class_name => "AdminImentore::Template", 
      :foreign_key => "theme_id",
      :dependent => :destroy
    has_many :assets, :class_name => "AdminImentore::Asset", 
      :foreign_key => "theme_id",
      :dependent => :destroy
      # :as => 'assetable'
    has_many :stores_themes, :class_name => Imentore::Theme, 
      :foreign_key => "admin_imentore_theme_id"

    scope :active, where(active: true)

    def self.install_store(store)
      self.active.each do |admin_theme|
        admin_theme.install_store(store)
      end
      store.themes.first.update_attribute(:active, true)
    end

    def install_stores
      Imentore::Store.all.each do |store|
        self.install_store(store)
      end
    end

    def update_stores
      self.templates.each do |admin_template|
        admin_template.stores_templates.each do |store_template|
          store_template.update_attribute(:body, admin_template.body)
        end
      end
    end

    def install_store(store)
      begin
        if store.themes.find_by_name(self.name).nil?
          theme = Imentore::Theme.create(name: self.name, admin_imentore_theme_id: self.id, store: store, system: true)
          self.templates.each do |ad_t|
            template = theme.templates.new
            template.path = ad_t.path
            template.layout = ad_t.layout
            template.kind = ad_t.kind
            template.default = true if template.kind == "layout"
            template.body = ad_t.body
            template.admin_imentore_template_id = ad_t.id
            template.save
          end
          self.assets.each do |admin_asset|
            asset = theme.assets.create(file: admin_asset.file)
          end
        return
          Rails.logger.debug { "store =>#{store.id}" }
          Rails.logger.debug { "theme =>#{self.id}" }
        end
      end
    end

  end
end