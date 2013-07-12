require 'test_helper'
require 'ostruct'


class OmniauthCallbacksControllerTest < ActionController::TestCase
  test 'get twitter' do
    #user and provider exist
    provider = Provider.find(2)
    user = provider.user
    omni_auth = OpenStruct.new
    omni_auth.provider = provider.soc_net_name
    omni_auth.uid = provider.uid
    request.env['omniauth.auth'] = omni_auth
    @request.env["devise.mapping"] = Devise.mappings[:user]
    post  :twitter
    userTest = assigns(:user)
    providerTest = assigns(:provider)
    assert_equal user, userTest
    assert_equal provider, providerTest
    assert_redirected_to :root
    #chicking, if user is signed in
    user_id =  session['warden.user.user.key']
    assert_not_nil user_id
    assert_equal user_id[0][0], user.id
    #user and provider dont exist
    #user is not signed in
    omni_auth = OpenStruct.new
    omni_auth.provider = 'twitter'
    omni_auth.uid = 10
    request.env['omniauth.auth'] = omni_auth
    @request.env["devise.mapping"] = Devise.mappings[:user]
    post :twitter
    user_id =  session['warden.user.user.key']
    assert_not_nil user_id
    assert_redirected_to '/users/get_info'
    #user is signed in
    user = User.find(2)
    sign_in user
    omni_auth = OpenStruct.new
    omni_auth.provider = 'twitter'
    omni_auth.uid = 20
    request.env['omniauth.auth'] = omni_auth
    @request.env["devise.mapping"] = Devise.mappings[:user]
    post :twitter
    user_id =  session['warden.user.user.key']
    assert_not_nil user_id
    assert_redirected_to  '/users/get_info'
  end
end
