require 'resolver'

ApplicationController.class_eval do
  prepend_view_path ::SqlTemplate::Resolver.instance

  layout "application"
end