module Imentore
  module Manager
    class BaseController < ::ApplicationController
      # include Imentore::BaseHelper
      # include Imentore::Manager::Engine.routes.url_helpers
      before_action :authorize_manager
      layout "manager"

      def authorize_manager
        unless user_signed_in? and (current_user.email == "admin@imentore.com.br")
          sign_out
          redirect_to(new_manager_session_url, alert: t(:permission_denied))
        end
      end
    end
  end
end