# module Imentore
  module AdminImentore
    class SessionsController < Devise::SessionsController
      include AdminImentore::Admin::Engine.routes.url_helpers
      layout "admin_imentore"

      def create
        params[:user].merge!(store_id: current_store.id)
        super
      end

      def after_sign_in_path_for(resource)
        if user_signed_in? and resource.email == "admin@myshop.com"
          admin_imentore_dashboard_path
        else
          sign_out
          redirect_to(new_admin_imentore_session_url, alert: t(:permission_denied))
        end
      end

    end
  end
# end 