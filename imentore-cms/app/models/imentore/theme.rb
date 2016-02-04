module Imentore
  class Theme < ActiveRecord::Base
    belongs_to :store
    belongs_to :manager_theme, :class_name => Imentore::Manager::Theme, :foreign_key => "admin_imentore_theme_id"
    
    has_many :folders, :class_name => Imentore::AssetFolder, :foreign_key => "theme_id", :dependent => :destroy
    has_many :templates, class_name: Imentore::Template, :dependent => :destroy
    has_many :assets, through: :folders, source: :assets


    scope :theme_system, -> { where(system: true) }
    # scope :default, where(default: true)

    def default_layout
      layout_name = templates.find_by_default(true).try(:path)
      layout_name ||= templates.find_by_path('layouts/#{name}".downcase').try(:path)
    end
  end
end