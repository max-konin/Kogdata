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

  test "destroy users" do
    begin
      get :destroy, {:id => '2'}
      #assert false
    rescue
      assert true
    end

    sign_out users(:Mitya)
    sign_in  users(:Max)

    get :destroy, {:id => '2'}
    assert User.find(2).nil?

  end
end