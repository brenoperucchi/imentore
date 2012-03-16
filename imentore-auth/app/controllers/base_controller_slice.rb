Imentore::BaseController.class_eval do
  def after_sign_in_path_for(resource)
    resource.userable.owner? ? admin_dashboard_path : root_path
  end
end