$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "imentore-cms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "imentore-cms"
  s.version     = Imentore::CMS::VERSION
  s.authors     = ["Breno Perucchi"]
  s.email       = ["bperucchi@gmail.com"]
  s.homepage    = ""
  s.summary     = "Summary of ImentoreUser."
  s.description = "Description of ImentoreUser."

  s.files = Dir["{app,config,db,lib,vendor}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails",               "~> 4.0.13"
  s.add_dependency "carrierwave",         "~> 0.7.0"
  s.add_dependency "mini_magick",         "~> 4.2.7"
  s.add_dependency "liquid",              "~> 3.0.3"
  s.add_dependency "inherited_resources", "~> 1.6.0"
  s.add_dependency "simple_form"
  s.add_dependency "devise"
  s.add_dependency "slim"
  s.add_dependency "country_select"
  s.add_dependency "paranoia"


  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
