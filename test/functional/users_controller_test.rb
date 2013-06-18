require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "destroy users" do
    sign_in  users(:Max)

    get :destroy, {:id => '2'}
    assert !User.exists?(2), "user didn't delete"
  end

  test "authorize for admin action" do
    sign_in  users(:Mitya)

    #destroy action test
    begin
      get :destroy, {:id => '1'}
      assert false, 'not the admin deleted user'
    rescue
      assert true
    end

  end

  test "show" do
    sign_in  users(:Mitya)
    get :show, {:id => 1}
    assert_response :success
    assert 1 == assigns(:user).id
    assert_template :show
  end


  test "select all users" do
    sign_in  users(:Max)
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    users = assigns(:users)
    assert (users.count == User.all.count)
    assert_template :index
  end

  test "select all photographers" do
    sign_in  users(:Mitya)
    get :index, {:role => 'contractor'}
    assert_response :success
    users = assigns :users
    users.each do |user|
      assert user.role? :contractor
    end
    assert_template :index
  end

  test "select users with fake role" do
    sign_in  users(:Mitya)
    begin
      get :index, {:role => 'fake'}
      assert false
    rescue
      assert true
    end
  end

end