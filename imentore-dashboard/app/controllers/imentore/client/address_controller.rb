module Imentore
  module Client
    class AddressController < Client::BaseController
      inherit_resources
      defaults :resource_class => Address, :collection_name => 'addresses', :instance_name => 'address'

      def begin_of_association_chain
        current_user.userable
      end

    end
  end
end