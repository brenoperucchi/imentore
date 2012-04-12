require "pry"
require "pry-nav"

require "capybara/webkit"
Capybara.javascript_driver = :webkit

Cucumber::Rails::Database.javascript_strategy = :truncation

Cucumber::Rails::World.class_eval do
  include Imentore::Core::Engine.routes.url_helpers
end

require "imentore-testing/factories"

Dir["#{File.dirname(__FILE__)}/step_definitions/**/*.rb"].each { |f| require f }

Imentore.config.domain = "imentore.dev"
