Imentore::Admin::BaseController.class_eval do
  before_filter :authorize_admin

  def authorize_admin
    unless(user_signed_in? && current_user.userable.owner?)
      redirect_to(root_url, alert: :permission_denied)
    end
  end
end