require 'test_helper'

class AssetFoldersControllerTest < ActionController::TestCase
  setup do
    @asset_folder = asset_folders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:asset_folders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create asset_folder" do
    assert_difference('AssetFolder.count') do
      post :create, asset_folder: {  }
    end

    assert_redirected_to asset_folder_path(assigns(:asset_folder))
  end

  test "should show asset_folder" do
    get :show, id: @asset_folder
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @asset_folder
    assert_response :success
  end

  test "should update asset_folder" do
    patch :update, id: @asset_folder, asset_folder: {  }
    assert_redirected_to asset_folder_path(assigns(:asset_folder))
  end

  test "should destroy asset_folder" do
    assert_difference('AssetFolder.count', -1) do
      delete :destroy, id: @asset_folder
    end

    assert_redirected_to asset_folders_path
  end
end
