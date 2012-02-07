module ApplicationControllerDecorator
  def after_sign_in_path_for(resource)
    'http://google.com'
  end
end

ApplicationController.class_eval do
  def after_sign_in_path_for(resource)
    resource.userable.department == 'owner' ? admin_dashboard_path : root_path
  end
end