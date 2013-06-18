require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    sign_in users(:Mitya)
  end

  test "select all users" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    users = assigns(:users)
    assert (users.count == User.all.count)
  end
end