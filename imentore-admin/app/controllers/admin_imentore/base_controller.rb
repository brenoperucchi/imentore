module AdminImentore
  class BaseController < ::ApplicationController
    include AdminImentore::Admin::Engine.routes.url_helpers
    layout "admin_imentore"
    before_filter :authorize_admin

    def authorize_admin
      unless user_signed_in? and (current_user.email == "admin@myshop.com" or current_user.email == "admin@imentore.com.br")
        sign_out
        redirect_to(new_admin_imentore_session_url, alert: t(:permission_denied))
      end
    end      
  end
end