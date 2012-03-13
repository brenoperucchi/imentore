module Imentore
  class SessionsController < Devise::SessionsController
    include Imentore::Core::Engine.routes.url_helpers
  end
end