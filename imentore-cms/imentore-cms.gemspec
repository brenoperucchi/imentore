$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "imentore-cms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "imentore-cms"
  s.version     = Imentore::CMS::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ImentoreCms."
  s.description = "TODO: Description of ImentoreCms."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails",               "~> 3.2.2"
  s.add_dependency "carrierwave",         "~> 0.6.1"
  s.add_dependency "mini_magick",         "~> 3.4"
  s.add_dependency "liquid",              "~> 2.3.0"
  s.add_dependency "inherited_resources", "~> 1.3.0"
  s.add_dependency "devise",              "~> 2.0.4"
  s.add_dependency "simple_form",         "~> 1.5.2"
  s.add_dependency "slim",                "~> 1.1.0"
  s.add_dependency "country_select",      "~> 0.0.1"

  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
