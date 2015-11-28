require 'test_helper'

class MinisoundsControllerTest < ActionController::TestCase
  setup do
    @minisound = minisounds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:minisounds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create minisound" do
    assert_difference('Minisound.count') do
      post :create, minisound: { movie_id: @minisound.movie_id, name: @minisound.name, playtime: @minisound.playtime }
    end

    assert_redirected_to minisound_path(assigns(:minisound))
  end

  test "should show minisound" do
    get :show, id: @minisound
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @minisound
    assert_response :success
  end

  test "should update minisound" do
    patch :update, id: @minisound, minisound: { movie_id: @minisound.movie_id, name: @minisound.name, playtime: @minisound.playtime }
    assert_redirected_to minisound_path(assigns(:minisound))
  end

  test "should destroy minisound" do
    assert_difference('Minisound.count', -1) do
      delete :destroy, id: @minisound
    end

    assert_redirected_to minisounds_path
  end
end
