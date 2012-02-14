module Imentore
  class Settings
    module Virtual
      def self.attributes
        [:public_access, :ir_tax]
      end

      def self.included(base)
        base << self.attributes
        base.class_eval do
          validates :public_access, presence: true, length: { minimum: 2 }
          validates :ir_tax, presence: true
        end
      end
    end
  end
end