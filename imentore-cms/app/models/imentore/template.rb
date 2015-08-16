module Imentore
  class Template < ActiveRecord::Base

    scope :layouts,   -> { where(kind: 'layout') }
    scope :templates, -> { where(kind: 'template') }
    belongs_to :theme
    belongs_to :layout, :class_name => Imentore::Template, :foreign_key => "layout_id"
    belongs_to :manager_template, :class_name => Imentore::Manager::Template, :foreign_key => "admin_imentore_template_id"

    # def layout
    #   self.read_attribute(:layout).present? ? self.read_attribute(:layout) : nil
    # end

    # validates :default, uniqueness: { scope: :theme_id }, :if => Proc.new { |klass| klass.default and klass.kind == 'layout'}
  end
end
