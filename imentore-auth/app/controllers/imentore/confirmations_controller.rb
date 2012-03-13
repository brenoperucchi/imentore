module Imentore
  class ConfirmationsController < Devise::ConfirmationsController
    include Imentore::Core::Engine.routes.url_helpers
  end
end