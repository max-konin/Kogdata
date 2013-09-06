require 'test_helper'

class SocialLinksControllerTest < ActionController::TestCase
  test 'client cannot create social links' do
    current_user = users(:Mitya)
    sign_in current_user
    assert_raises(CanCan::AccessDenied) do
      post :create, {:user_id => current_user.id }
    end
  end

  test 'invalid link cannot be saved' do
    current_user = users(:Adarich)
    sign_in current_user
    post :create, {:user_id => current_user.id, :social_link => {:url => 'fake'}}
    assert_redirected_to '/users/edit'
  end

  test 'save valid link' do
    request.env['HTTP_REFERER'] = 'http://localhost:3000/'
    current_user = users(:Adarich)
    sign_in current_user
    post :create, {:user_id => current_user.id, :social_link => {:url => 'fake',
                                                                 :provider => 'vkontakte'}}
    assert_not_nil assigns(:social_link).id
  end

end