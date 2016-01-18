Imentore::BaseController.class_eval do
  # before_action :current_cart
  helper_method :current_cart

  def sort_column
    case params['sort-by']
    when nil
      "created_at desc"
    when "recent"
      "created_at desc"
    when "name_a_z"
      "name asc"
    when "name_z_a"
      "name desc"
    when "price_low"
      "name desc"
    end
  end


  def current_cart
    @current_cart = current_store.carts.find_by_id(session[:cart_id])
  end
end