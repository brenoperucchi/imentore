module Imentore
  module Admin
    class AssetFoldersController < BaseController
      before_action :set_asset_folder, only: [:show, :edit, :update, :destroy]

      respond_to :html, :js

      def index
        @theme = current_store.themes.find(params[:theme_id])
        @folder = @theme.folders.first || @theme.folders.create(name: "root", store: current_store)
        @folders = @theme.folders.roots
        respond_with(@folders)
      end

      def new
        @theme = current_store.themes.find(params[:theme_id])
        @parent = @theme.folders.find_by_id(params[:parent_id])
        @folder = @theme.folders.new(parent_id: params[:parent_id], store: current_store)
        respond_with(@folder)
      end

      def create
        @theme = current_store.themes.find(params[:theme_id])
        @folder = @theme.folders.new(asset_folder_params)
        flash[:notice] = 'Imentore::AssetFolder was successfully created.' if @folder.save
        @folders = @theme.folders.roots
        respond_with(@folder, location:admin_theme_asset_folders_path)
        # respond_with([:admin, @folder]) do |format|
        #   if @folder.save
        #     flash[:notice] = 'Task was successfully created.'
        #   else
        #     @folders = Imentore::AssetFolder.all
        #     format.html { render :new }
        #   end
        # end

      end

      def update
        flash[:notice] = 'Imentore::AssetFolder was successfully updated.' if @folder.update(asset_folder_params)
        respond_with([:admin, @folder])
      end

      def destroy
        @folder.destroy
        respond_with(@folder, location:admin_theme_asset_folders_path)
      end

      private
        def set_asset_folder
          @theme = current_store.themes.find(params[:theme_id])
          @folder = @theme.folders.find(params[:id])
          @folders = @theme.folders.roots
        end

        def asset_folder_params
          params.require(:asset_folder).permit(:name, :parent_id, :theme_id, :store_id)
        end
    end
  end
end