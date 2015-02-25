# module Imentore
  module AdminImentore
    class SessionsController < Devise::SessionsController
      include AdminImentore::Admin::Engine.routes.url_helpers
      skip_before_filter :check_store
      layout "admin_imentore"

      # SABER O QUE ISSO FAZ
      def create
        params[:user].merge!(store_id: 1)
        super
      end

      def after_sign_out_path_for(resource)
        new_admin_imentore_session_path
      end

      def after_sign_in_path_for(resource)
        if user_signed_in? and resource.email == "admin@imentore.com.br"
          admin_imentore_dashboard_path
        else
          sign_out
          redirect_to(new_admin_imentore_session_url, alert: t(:permission_denied))
        end
      end

    end
  end
# end 