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

    has_many :stores_themes, :class_name => Imentore::Theme, :foreign_key => "admin_imentore_theme_id"

    def install_stores
      Imentore::Store.all.each do |store|
        if store.themes.find_by_name(self.name).nil?
          theme = Imentore::Theme.create(name: self.name, admin_imentore_theme_id: self.id, store: store, system: true)
          self.templates.each do |ad_t|
            template = theme.templates.new
            template.path = ad_t.path
            template.layout = ad_t.layout
            template.kind = ad_t.kind
            template.default = true if template.kind == "layout"
            template.body = ad_t.body
            template.body_default = ad_t.body
            template.admin_imentore_template_id = ad_t.id
            template.save
          end
          self.assets.each do |admin_asset|
            asset = theme.assets.create(file: admin_asset.file)
          end
        end
      end


    end

  end
end