$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "imentore-dashboard/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "imentore-dashboard"
  s.version     = Imentore::Dashboard::VERSION
  s.authors     = ["Breno Perucchi"]
  s.email       = ["bperucchi@gmail.com"]
  s.homepage    = ""
  s.summary     = "Summary of ImentoreUser."
  s.description = "Description of ImentoreUser."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  # s.add_dependency "rails", "~> 3.2.3"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
