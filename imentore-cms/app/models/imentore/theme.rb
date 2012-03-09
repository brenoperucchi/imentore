module Imentore
  class Theme < ActiveRecord::Base
    belongs_to :store
    has_many :templates

    validates :name,  presence: true

    scope :default, where(default: true)

    def default_layout
      layout_name = "layouts/#{name}".downcase
      layout_name if templates.find_by_path(layout_name)
    end
  end
end