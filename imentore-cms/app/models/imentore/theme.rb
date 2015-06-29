module Imentore
  class Theme < ActiveRecord::Base
    belongs_to :store
    belongs_to :admin_theme, :class_name => AdminImentore::Theme, :foreign_key => "admin_imentore_theme_id"
    
    has_many :templates, class_name: Imentore::Template, :dependent => :destroy
    has_many :assets, :dependent => :destroy


    scope :theme_system, -> { where(system: true) }
    # scope :default, where(default: true)

    def default_layout
      layout_name = templates.find_by_default(true).try(:path)
      layout_name ||= templates.find_by_path('layouts/#{name}".downcase').try(:path)
    end
  end
end