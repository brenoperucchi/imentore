module AdminImentore
  class StoresController < AdminImentore::BaseController
    inherit_resources
    defaults :resource_class => Imentore::Store, :collection_name => 'stores', :instance_name => 'store'

    def index
      @old_stores = Old::Store.active
      @stores = Imentore::Store.all
    end

    def install_store
      old_store = Old::Store.find(params[:id])
      if AdminImentore::Store.install_store(old_store)
        flash[:notice] = "Successfully install store`"
        redirect_to admin_imentore_stores_path
      else
        flash[:alert] = "Failure install store"
        redirect_to admin_imentore_stores_path
      end
    end

    def reinstall_theme
      theme = Imentore::Theme.find(params(:id))
      admin_theme = theme.admin_theme
      if admin_theme.reinstall(current_store, theme)
        flash[:notice] = "Successfully"
        redirect_to admin_imentore_stores_path
      else
        flash[:alert] = "Failure"
        redirect_to admin_imentore_stores_path
      end
    end

    def update
      update! { admin_imentore_stores_path }
    end

  end
end