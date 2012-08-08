require 'ostruct'

class String
  def to_underscore!
    str = self
    str.gsub!(/::/, '/')
    str.gsub!(' ', '_')
    str.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    str.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    str.tr!("-", "_")
    str.downcase
  end
  def to_underscore
    str = self
    str = str.gsub(/::/, '/')
    str = str.gsub(' ', '_')
    str = str.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    str = str.gsub(/([a-z\d])([A-Z])/,'\1_\2')
    str = str.tr("-", "_")
    str.downcase
  end
end

module Imentore
  extend self

  def defaults
    {
      domain: ["imentore.dev", "imentore.com","imentore.com.br"]
    }
  end

  def config
    @config ||= OpenStruct.new(defaults)
  end
end

# if Rails.env.development?
#   Imentore.config.domain = "imentore.dev"
# end
