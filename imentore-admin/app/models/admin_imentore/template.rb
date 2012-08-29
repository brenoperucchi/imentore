module AdminImentore
  class Template < ActiveRecord::Base

    def self.table_name 
      "admin_imentore_templates"
    end

    scope :layouts, where(kind: 'layout')
    scope :templates, where(kind: 'template')

    belongs_to :theme
    has_many :stores_templates, :class_name => Imentore::Template, :foreign_key => "admin_imentore_template_id"

  end
end