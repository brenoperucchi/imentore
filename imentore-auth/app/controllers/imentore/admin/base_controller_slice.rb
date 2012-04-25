Imentore::Admin::BaseController.class_eval do
  before_filter :authorize_admin

  def authorize_admin
    unless(user_signed_in? && current_user.userable.owner?)
      redirect_to(new_admin_session_url, alert: :permission_denied)
    end
  end
end