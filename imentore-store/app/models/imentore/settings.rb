module Imentore
  class Settings# < Hash
    include ActiveModel::Conversion
    extend ActiveModel::Naming
    extend ActiveModel::Translation
    include ActiveModel::Validations
    include ActiveModel::AttributeMethods

    class_attribute :_attributes
    self._attributes = []

    def self.<<(attrs)
      attr_accessor *attrs
      self._attributes += [*attrs]
    end

    def attributes
      self._attributes.inject({}) do |hash, attr|
        hash[attr.to_s] = send(attr)
        hash
      end
    end

    def persisted?
      false
    end

    def attributes=(attrs)
      attrs.each do |attr, value|
        send("#{attr}=", value)
      end
    end

    include Virtual

  #
  #   # def theme?
  #   #   fetch('theme')+ "_" + theme_variant
  #   # end
  #
  #
  #   def []=(key,value)
  #     value.delete_if { |i| i.blank? } if value.is_a?(Array)
  #     super
  #   end
  #
  #   # def [](key)
  #   #   return Imentore.send(key) unless key?(key)
  #   #   val = fetch(key)
  #   #   return Delocalize::LocalizedNumericParser.parse(val) if val.is_a?(String) && val.match(/\d/)
  #   #   super
  #   # end
  #
  #   def [](key)
  #     return Imentore.send(key) unless key?(key)
  #     val = fetch(key)
  #     # Rails.logger.debug { "val=> #{val}"}
  #     # Rails.logger.debug { "key=> #{key }"}
  #     unless has_string?(val)
  #       # Rails.logger.debug { "teste=> #{ }"}
  #       # val.match(/\d/)
  #       # Rails.logger.debug { "valdentro=> #{val }"}
  #       val = Delocalize::LocalizedNumericParser.parse(val)
  #       # Rails.logger.debug { "valdentro2=> #{val }"}
  #       # super
  #     end
  #     return val
  #   end
  #
  #   def method_missing(key, *args)
  #     self.try(:[], key.to_s)
  #   end
  #
  #   def has_string?(val)
  #     (val =~ /[a-zA-Z]/ ) != nil
  #   end
  #
  end
end