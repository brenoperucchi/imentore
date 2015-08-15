module Imentore 
  module Manager
    class BaseController < ::ApplicationController
      include Imentore::Core::Engine.routes.url_helpers

      layout "manager"
      skip_before_action :check_store
      before_action :authorize_admin

      def authorize_admin
        unless user_signed_in? and (current_user.email == "admin@imentore.com.br")
          sign_out
          redirect_to(new_manager_session_url, alert: t(:permission_denied))
        end
      end      
    end
  end
end