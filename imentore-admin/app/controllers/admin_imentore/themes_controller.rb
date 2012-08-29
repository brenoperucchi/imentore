module AdminImentore
  class ThemesController < AdminImentore::BaseController
    inherit_resources
    defaults :resource_class => AdminImentore::Theme, :collection_name => 'themes', :instance_name => 'theme'
    def index
      @themes = AdminImentore::Theme.all
    end

    def new
      @theme = AdminImentore::Theme.new
    end

    def update
      update! { admin_imentore_themes_path}
    end

    def create
      @theme = AdminImentore::Theme.new(params[:theme])
      if @theme.save
        redirect_to admin_imentore_themes_path
      else 
        render :new
      end
    end

    def install_stores
      admin_theme = AdminImentore::Theme.find(params[:id])
      admin_theme.install_stores
      flash[:success] = "Successfully created..."
      redirect_to admin_imentore_themes_path
    end

  end
end