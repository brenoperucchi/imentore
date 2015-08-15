module Imentore
  module Manager
    class SessionsController < Devise::SessionsController
      skip_before_action :check_store
      layout "manager"

      def after_sign_out_path_for(resource)
        new_manager_session_path
      end

      def after_sign_in_path_for(resource)
        if user_signed_in? and resource.email == "admin@imentore.com.br"
          manager_dashboard_path
        else
          sign_out
          redirect_to(new_manager_session_url, alert: t(:permission_denied))
        end
      end

    end
  end
end 