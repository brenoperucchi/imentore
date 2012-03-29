Imentore::BaseController.class_eval do
  before_filter :current_cart

  helper_method :current_cart

  def current_cart
    @current_cart ||= Imentore::Cart.find_by_id(session[:cart_id])

    unless @current_cart
      @current_cart = Imentore::Cart.create
      session[:cart_id] = @current_cart.id
    end

    @current_cart
  end
end
