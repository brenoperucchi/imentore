# Point RAILS_ROOT to the dummy app
ENV['RAILS_ROOT'] = File.expand_path('"../../../../imentore-base/"', __FILE__)
require "cucumber/rails"

require "imentore-testing/env"