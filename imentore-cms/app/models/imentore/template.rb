module Imentore
  class Template < ActiveRecord::Base
    scope :layouts, where(kind: 'layout')
    scope :templates, where(kind: 'template')
    belongs_to :theme

    validates :default, uniqueness: true, :if => Proc.new { |klass| klass.default and klass.kind == 'layout'}

  end
end
