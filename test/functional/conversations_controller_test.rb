require 'test_helper'

class ConversationsControllerTest < ActionController::TestCase
  test 'create message' do
    sign_in  users(:Mitya)
    request.env['HTTP_REFERER'] = 'http://localhost:3000/'
    post :create_message, {:id => 1, :message => {:body => 'body'}}
    assert assigns(:conversation).id == 1
    post :create_message, {:members => [1,3], :message => {:body => 'body'}}
  end

  test 'delete_message' do
    delete :delete_message, {:id => 2}
    assert_response :success
  end



end
