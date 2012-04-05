require 'test_helper'

class WorkUnitsControllerTest < ActionController::TestCase
  setup do
    @work_unit = work_units(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:work_units)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create work_unit" do
    assert_difference('WorkUnit.count') do
      post :create, :work_unit => @work_unit.attributes
    end

    assert_redirected_to work_unit_path(assigns(:work_unit))
  end

  test "should show work_unit" do
    get :show, :id => @work_unit
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @work_unit
    assert_response :success
  end

  test "should update work_unit" do
    put :update, :id => @work_unit, :work_unit => @work_unit.attributes
    assert_redirected_to work_unit_path(assigns(:work_unit))
  end

  test "should destroy work_unit" do
    assert_difference('WorkUnit.count', -1) do
      delete :destroy, :id => @work_unit
    end

    assert_redirected_to work_units_path
  end
end
