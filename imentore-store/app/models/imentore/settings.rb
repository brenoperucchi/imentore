module Imentore
  class Settings# < Hash
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