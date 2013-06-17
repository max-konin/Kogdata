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

  test "select all photographers" do
    get :index, {:role => 'contractor'}
    assert_response :success
    users = assigns :users
    users.each do |user|
      assert user.role? :contractor
    end
  end
  test "select users with fake role" do
    begin
      get :index, {:role => 'fake'}
      assert false
    rescue
      assert true
    end

  end
end