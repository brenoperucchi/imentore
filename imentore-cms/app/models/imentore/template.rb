module Imentore
  class Template < ActiveRecord::Base

    include AdminImentore

    scope :layouts, where(kind: 'layout')
    scope :templates, where(kind: 'template')
    belongs_to :theme

    belongs_to :admin_template, :class_name => AdminImentore::Template, :foreign_key => "admin_imentore_template_id"

    # validates :default, uniqueness: { scope: :theme_id }, :if => Proc.new { |klass| klass.default and klass.kind == 'layout'}
  end
end
