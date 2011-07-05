require 'test_helper'

class AnnotationsControllerTest < ActionController::TestCase
  setup do
    @annotation = annotations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:annotations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create annotation" do
    assert_difference('Annotation.count') do
      post :create, :annotation => @annotation.attributes
    end

    assert_redirected_to annotation_path(assigns(:annotation))
  end

  test "should show annotation" do
    get :show, :id => @annotation.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @annotation.to_param
    assert_response :success
  end

  test "should update annotation" do
    put :update, :id => @annotation.to_param, :annotation => @annotation.attributes
    assert_redirected_to annotation_path(assigns(:annotation))
  end

  test "should destroy annotation" do
    assert_difference('Annotation.count', -1) do
      delete :destroy, :id => @annotation.to_param
    end

    assert_redirected_to annotations_path
  end
end
