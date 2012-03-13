module Imentore
  module Admin
    class SessionsController < Devise::SessionsController
      include Imentore::Core::Engine.routes.url_helpers

      layout "admin"
    end
  end
end