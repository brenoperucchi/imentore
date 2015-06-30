module AdminImentore
  class TemplatesController < AdminImentore::BaseController
    inherit_resources
    defaults :resource_class => AdminImentore::Template, :collection_name => 'templates', :instance_name => 'template'
    belongs_to :theme, parent_class: AdminImentore::Theme

    def new
      @kind = params[:kind]
      @asset = parent.assets.all
      new!
    end

    def edit
      @template = parent.templates.find(params[:id])
      @kind = @template.kind
    end

    def create
      create! { admin_imentore_theme_templates_path(params[:theme_id]) }
    end

    def update
      update! { admin_imentore_theme_templates_path(params[:theme_id]) }
    end

    def destroy
      destroy! { admin_imentore_theme_templates_path(params[:theme_id]) }
    end

    def update_stores
      admin_template = AdminImentore::Template.find(params[:id])
      stores_templates = admin_template.stores_templates        
      stores_templates.each do |template| 
        template.body = admin_template.body
        template.updated_at = DateTime.now.utc
        template.save
      end
      flash[:success] = "Successfully created..."
      redirect_to admin_imentore_theme_templates_path(params[:theme_id])
    end

    def install_stores
      admin_template = AdminImentore::Template.find(params[:id])
      stores_templates = admin_template.theme.stores_themes
      stores_templates.each do |theme| 
        unless theme.templates.find_by_path(admin_template.path).present?
          template = theme.templates.new
          template.path = admin_template.path
          template.body = admin_template.body
          template.layout = admin_template.layout
          template.kind = "template"
          template.updated_at = DateTime.now.utc
          template.admin_template = admin_template
          template.save
        end
      end
      flash[:success] = "Successfully created..."
      redirect_to admin_imentore_theme_templates_path(params[:theme_id])
    end
    
    protected
    def template_params
      params.require(:admin_imentore_template).permit(:default, :body, :path, :kind, :layout_id)
    end


  end
end