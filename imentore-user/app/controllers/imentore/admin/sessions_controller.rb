module Imentore
  module Admin
    class SessionsController < Devise::SessionsController
      layout "admin"
    end
  end
end