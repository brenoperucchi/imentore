require 'test_helper'

class Admin::AssetFoldersControllerTest < ActionController::TestCase
  setup do
    @admin_asset_folder = admin_asset_folders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_asset_folders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_asset_folder" do
    assert_difference('Admin::AssetFolder.count') do
      post :create, admin_asset_folder: {  }
    end

    assert_redirected_to admin_asset_folder_path(assigns(:admin_asset_folder))
  end

  test "should show admin_asset_folder" do
    get :show, id: @admin_asset_folder
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_asset_folder
    assert_response :success
  end

  test "should update admin_asset_folder" do
    patch :update, id: @admin_asset_folder, admin_asset_folder: {  }
    assert_redirected_to admin_asset_folder_path(assigns(:admin_asset_folder))
  end

  test "should destroy admin_asset_folder" do
    assert_difference('Admin::AssetFolder.count', -1) do
      delete :destroy, id: @admin_asset_folder
    end

    assert_redirected_to admin_asset_folders_path
  end
end
