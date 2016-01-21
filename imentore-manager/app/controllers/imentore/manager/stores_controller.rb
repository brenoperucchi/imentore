module Imentore
  module Manager
    class StoresController < Manager::BaseController
      inherit_resources
      defaults :resource_class => Imentore::Store, :collection_name => 'stores', :instance_name => 'store'

      def index
        @old_stores = []
        @stores = Imentore::Store.all
      end

      def install_store
        old_store = Old::Store.find(params[:id])
        if AdminImentore::Store.install_store(old_store)
          flash[:notice] = "Successfully install store`"
          redirect_to manager_stores_path
        else
          flash[:alert] = "Failure install store"
          redirect_to manager_stores_path
        end
      end

      def reinstall_theme
        theme = Imentore::Theme.find(params[:id])
        admin_theme = theme.admin_theme
        if admin_theme.reinstall(theme.store, theme)
          flash[:notice] = "Successfully"
          redirect_to manager_stores_path
        else
          flash[:alert] = "Failure"
          redirect_to manager_stores_path
        end
      end

      def update
        update! { manager_stores_path }
      end

      def destroy
        destroy! { manager_stores_path }
      end

    end
  end
end