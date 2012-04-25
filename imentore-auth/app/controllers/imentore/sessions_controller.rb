module Imentore
  class SessionsController < Devise::SessionsController
    skip_before_filter :require_no_authentication
  end
end