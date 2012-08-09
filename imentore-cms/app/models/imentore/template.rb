module Imentore
  class Template < ActiveRecord::Base
    scope :layouts, where(kind: 'layout')
    scope :templates, where(kind: 'template')
    belongs_to :theme

    validates :default, uniqueness: { scope: :theme_id }, :if => Proc.new { |klass| klass.default and klass.kind == 'layout'}

  end
end
