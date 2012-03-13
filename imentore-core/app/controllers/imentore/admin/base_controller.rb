module Imentore
  module Admin
    class BaseController < ::ApplicationController
      include Imentore::Core::Engine.routes.url_helpers

      layout "admin"

      helper_method :current_store

      def current_store
        @current_store ||= Imentore::Store.find_by_url(request.subdomain)
      end
    end
  end
end
