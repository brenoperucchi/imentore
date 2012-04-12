module Imentore
  extend self

  def defaults
    {
      domain: "imentore.com"
    }
  end

  def config
    @config ||= OpenStruct.new(defaults)
  end
end
