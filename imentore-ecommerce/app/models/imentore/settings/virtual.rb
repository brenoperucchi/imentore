module Imentore
  class Settings
    module Virtual
      def self.attributes
        :theme
      end

      attr_accessor *attributes

      def self.included(base)
        base.register_attributes *attributes
        base.class_eval do
          validates :theme, presence: true
        end
      end

      def theme
        @theme || :default
      end
    end
  end
end