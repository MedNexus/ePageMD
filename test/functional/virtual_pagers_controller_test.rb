require 'test_helper'

class VirtualPagersControllerTest < ActionController::TestCase
  setup do
    @virtual_pager = virtual_pagers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:virtual_pagers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create virtual_pager" do
    assert_difference('VirtualPager.count') do
      post :create, :virtual_pager => @virtual_pager.attributes
    end

    assert_redirected_to virtual_pager_path(assigns(:virtual_pager))
  end

  test "should show virtual_pager" do
    get :show, :id => @virtual_pager.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @virtual_pager.to_param
    assert_response :success
  end

  test "should update virtual_pager" do
    put :update, :id => @virtual_pager.to_param, :virtual_pager => @virtual_pager.attributes
    assert_redirected_to virtual_pager_path(assigns(:virtual_pager))
  end

  test "should destroy virtual_pager" do
    assert_difference('VirtualPager.count', -1) do
      delete :destroy, :id => @virtual_pager.to_param
    end

    assert_redirected_to virtual_pagers_path
  end
end
