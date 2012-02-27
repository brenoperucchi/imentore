require "pry"

# require "capybara/webkit"
Capybara.javascript_driver = :webkit

Cucumber::Rails::Database.javascript_strategy = :truncation

require "imentore-testing/factories"

Dir["#{File.dirname(__FILE__)}/step_definitions/**/*.rb"].each { |f| require f }