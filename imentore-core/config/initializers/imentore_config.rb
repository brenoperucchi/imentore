require 'ostruct'
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
