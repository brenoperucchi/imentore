Imentore::Client::BaseController.class_eval do

  # def after_sign_in_path_for(resource)
  #   resource.userable.owner? ? admin_dashboard_path : client_dashboard_path
  # end

  before_filter :authorize_client

  def authorize_client
    if(user_signed_in? && current_user.userable.owner?)
      redirect_to(new_admin_session_url, alert: t(:permission_denied))
    elsif not(user_signed_in?)
      redirect_to(new_client_session_path)
    end
  end

end