module Imentore
  class Theme < ActiveRecord::Base
    belongs_to :store
    has_many :templates
    has_many :assets

    scope :theme_system, where(system: true)
    scope :default, where(default: true)

    def default_layout
      layout_name = templates.find_by_default(true).try(:path)
      layout_name ||= templates.find_by_path('layouts/#{name}".downcase').try(:path)
    end
  end
end