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

  test 'post create' do
    provider = Provider.new
    provider.uid = 4
    provider.soc_net_name = 'facebook'
    session['devise.provider'] = provider
    post :create, {:user => {:name => 'vasya1', :email => 'v1@v.ru', :role => 'client', :password => '12345'}}
    provider = Provider.where(:soc_net_name => 'facebook', :uid => 4).first
    user = User.where(:email => 'v1@v.ru').first
    assert_response :found
    assert provider.user_id == user.id
    assert_redirected_to :root
    session['devise.provider'] = nil
    post :create, {:user => {:name => 'vasya2', :email => 'v2@v.ru', :role => 'client', :password => '12345'}}
    assert_response :found
    assert_redirected_to :root
  end

  test 'put registration after omniauth user is not signed in' do
    user = User.new
    provider = Provider.new
    session['devise.provider'] = provider
    session['devise.omniauth_data'] = user
    put :registration_after_omniauth
    assert_template 'users/after_omniauth'
  end

  test 'put registration after omniauth user is signed in provider without user_id' do
    user = User.find(2)
    sign_in user
    provider = Provider.new
    provider.soc_net_name = 'twitter'
    provider.uid = 101
    user1 = User.new
    session['devise.provider'] = provider
    session['devise.omniauth_data'] = user1
    put :registration_after_omniauth
    providerTest = Provider.where(:uid => 101).first
    assert_not_nil providerTest
    assert_redirected_to :root
  end

  test 'put registration after omniauth user is signed in provider has user_id equal to current user id' do
    user = User.find(2)
    sign_in user
    provider = Provider.new
    provider.soc_net_name = 'twitter'
    provider.uid = 101
    provider.user_id = user.id
    provider.save!
    session['devise.provider'] = provider
    session['devise.omniauth_data'] = user
    put :registration_after_omniauth
    providerTest = Provider.where(:uid => 101).first
    assert_not_nil providerTest
    assert_redirected_to :root
  end

  test 'put registration after omniauth user is signed in provider has user_id not equal to current user id' do
    user = User.find(2)
    sign_in user
    user1 = User.find(1)
    provider = Provider.new
    provider.soc_net_name = 'twitter'
    provider.uid = 101
    provider.user_id = user1.id
    provider.save!
    session['devise.provider'] = provider
    session['devise.omniauth_data'] = user1
    put :registration_after_omniauth
    providerTest = Provider.where(:uid => 101)
    assert_not_nil providerTest
    assert_redirected_to '/users/merge'
  end




end