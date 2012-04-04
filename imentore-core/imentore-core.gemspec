$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "imentore-core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "imentore-core"
  s.version     = Imentore::Core::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ImentoreCore."
  s.description = "TODO: Description of ImentoreCore."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.2"
  s.add_dependency 'country_select', '0.0.1'
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
