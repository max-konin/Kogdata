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
    currentUser = users :Adarich
    sign_in currentUser
    request.env['HTTP_REFERER'] = 'http://localhost:3000/'
    delete :delete_message, {:m_id => 2}
    assert !currentUser.messages.find_by_id(2)
  end

  test 'index' do
    #TODO Adarich
   true
  end

  test 'show' do
    sign_in users :Adarich
    get 'show', {:id => 1}
    assert assigns(:conversation).messages.first.id == 1, assigns(:conversation).inspect
  end
end
