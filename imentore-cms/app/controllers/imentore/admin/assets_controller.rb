module Imentore
  module Admin
    class AssetsController < BaseController
      inherit_resources
      belongs_to :theme
      actions :new, :create, :destroy

      def destroy
        destroy! { admin_theme_path(@asset.theme) }
      end

      def create
        filename = "#{ENV['TMPDIR']}/#{params[:qqfile]}"
          newf = File.open(filename, "wb")
          str =  request.body.read
          newf.write(str)
          newf.close
        @asset = current_store.themes.find(params[:theme_id]).assets.new(:file =>File.open(filename) )
        create! do |success, failure|
          failure.html{
            render :text => '{error:false}', :status => 404, :layout => false
          }
          success.html{
            render :text => '{success:true}', :status => 200, :layout => false
          }
        end
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
