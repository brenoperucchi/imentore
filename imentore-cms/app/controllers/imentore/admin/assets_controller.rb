module Imentore
  module Admin

    class AssetsController < Admin::BaseController
      inherit_resources
      # belongs_to :theme, parent_class: Imentore::Theme
      # belongs_to :store, parent_class: Imentore::Store

      # actions :new, :create, :show

      # def new
      #   new!

      # end

      def destroy
        destroy! do
          # flash[:notice] = "Successfully deleted"
          admin_theme_path(@asset.theme)
        end
      end

      def create

        Rails.logger.debug { "message=> #{params[:qqfile].inspect}"}
        Rails.logger.debug { "@upload=> #{request.body }"}
        # extension = params[:qqfile].match("\.([^\.]+)$")[0].include?(".") ? params[:qqfile].match("\.([^\.]+)$")[0] : ""
        # filename = "#{RAILS_ROOT}/public/system/tmp/" + "raw_file_#{rand(9)}#{extension}"
        filename = "#{ENV['TMPDIR']}/#{params[:qqfile]}"
          newf = File.open(filename, "wb")
          str =  request.body.read
          newf.write(str)
          newf.close
        # @upload = @cart_item.store_files.build(:file=> File.open(filename))
        @asset = current_store.themes.find(params[:theme_id]).assets.new(:file =>File.open(filename) )


        # @asset = current_store.themes.find(params[:theme_id]).assets.new(params[:asset])
        # @asset.store = current_store
        # @asset.filename = params[:asset][:file].original_filename if params[:asset].present? and params[:asset][:file].present?
        # binding.pry
        create! do |success, failure|
          failure.html{
            render :text => '{error:false}', :status => 404, :layout => false
          }
          success.html{
            render :text => '{success:true}', :status => 200, :layout => false
          }
        end
      end

      def begin_of_association_chain
        current_store.themes.find(params[:theme_id])
      end

    end
  end
end