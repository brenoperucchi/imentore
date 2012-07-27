module Imentore
  module Client
    class PasswordsController < Devise::PasswordsController
      layout "client"

    end
  end
end