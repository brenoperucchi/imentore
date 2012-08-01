module Imentore
  class Template < ActiveRecord::Base
    scope :layouts, where(kind: 'layout')
    scope :templates, where(kind: 'template')
    belongs_to :theme

    validates :default, uniqueness: { scope: :theme_id }, :if => Proc.new { |klass| klass.default and klass.kind == 'layout'}

    after_save :template_cached

    def template_cached
      SqlTemplate::Resolver.instance.clear_cache
    end

  end
end
