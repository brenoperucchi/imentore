module Imentore
  extend self

  class << self
    attr_accessor :configuration

    def configure
      @configuration ||= Configuration.new
      yield(configuration)
    end

  end

  class Configuration
    attr_accessor :cost_centers

    def initialize
      @cost_centers = []
    end
  end
end
