require 'test_helper'

class ConversationsControllerTest < ActionController::TestCase
  test "show" do
    get :show
    assert_response :success
  end

  test "delete_message" do
    get :delete_message, {:id => 2}
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
