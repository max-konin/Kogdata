require 'test_helper'

class BusynessesControllerTest < ActionController::TestCase

  test 'get index' do
    current_user_id = 2
    user = User.find(current_user_id)
    currDate = DateTime.parse '2013-07-01'
    startDate = DateTime.parse '2013-07-01 00:00:00'
    finishDate = DateTime.parse '2013-07-31 23:59:59'
    sign_in user
    bysEtalon = Busyness.where('user_id = ? AND date >= ? AND date <= ?',current_user_id,startDate,finishDate)
    get :index, {:user_id => current_user_id, :curr_date => currDate, :format => :json}
    assert_response :ok
    bysTest = assigns(:bysunesess)
    assert_not_nil bysTest
    assert_equal bysTest.count, bysEtalon.count
    bysTest.each do |bys|
      assert bys.date <= finishDate && bys.date >= startDate
    end
  end


  test 'put create for current user is contractor date is in month json' do
    current_user_id = 2
    user = User.find(current_user_id)
    currDate = DateTime.parse '2013-07-01'
    sign_in user
    date = DateTime.parse '2013-07-21 00:00:00'
    put :create, {:user_id => current_user_id, :curr_date => currDate, :date => date, :format => :json}
    assert_response :ok
    newBusyDay = Busyness.last
    assert newBusyDay.persisted?
    assert_equal newBusyDay.date, date
    resp = JSON.parse @response.body
    newBusyDay_id = resp['id']
    assert_equal newBusyDay.id, newBusyDay_id
  end

  test 'put create for current user is contractor date is in month html' do
    current_user_id = 2
    user = User.find(current_user_id)
    currDate = DateTime.parse '2013-07-01'
    sign_in user
    date = DateTime.parse '2013-07-21 00:00:00'
    put :create, {:user_id => current_user_id, :curr_date => currDate, :date => date, :format => :html}
    assert_redirected_to 'calendar/index'
    newBusyDay = Busyness.last
    assert newBusyDay.persisted?
    assert_equal newBusyDay.date, date
  end



  test 'put create not current user' do
    current_user_id = 2
    user = User.find(current_user_id)
    sign_in user
    put :create, {:user_id => 3}
    assert_response :forbidden
  end

  test 'put create date is not in month' do
    current_user_id = 2
    user = User.find(current_user_id)
    currDate = DateTime.parse '2013-09-01'
    sign_in user
    date = DateTime.parse '2013-07-21 00:00:00'
    put :create, {:user_id => current_user_id, :curr_date => currDate, :date => date, :format => :json}
    assert_response :unprocessable_entity
  end


  test 'put create user is not contractor' do
    current_user_id = 1
    user = User.find(current_user_id)
    currDate = DateTime.parse '2013-09-01 00:00:00'
    sign_in user
    date = DateTime.parse '2013-07-21 00:00:00'
    put :create, {:user_id => current_user_id, :curr_date => currDate, :date => date, :format => :json}
    assert_response :forbidden
  end

  test 'destroy delete current user is contractor date in month json' do
    current_user_id = 2
    user = User.find(current_user_id)
    currDate =  Busyness.find(1).date
    sign_in user
    busToDel = Busyness.find(2)
    delete :destroy, {:user_id => current_user_id,  :id => busToDel.id,:curr_date => currDate, :format => :json}
    assert !Busyness.exists?( busToDel.id), 'if record have been deleted'
  end


  test 'destroy delete current user is contractor date in month html' do
    current_user_id = 2
    user = User.find(current_user_id)
    currDate =  Busyness.find(1).date
    sign_in user
    busToDel = Busyness.find(2)
    delete :destroy, {:user_id => current_user_id,  :id => busToDel.id,:curr_date => currDate, :format => :html}
    assert_redirected_to 'calendar/index'
    assert !Busyness.exists?( busToDel.id), 'if record have been deleted'
  end

  test 'destroy delete not current user' do
    current_user_id = 2
    user = User.find(current_user_id)
    sign_in user
    delete :destroy, {:user_id => 1, :id => 1}
    assert_response :forbidden
  end

  test 'destroy delete current user is not contractor' do
    current_user_id = 1
    user = User.find(current_user_id)
    sign_in user
    delete :destroy, {:user_id => current_user_id, :id => 1}
    assert_response :forbidden
  end

  test 'destroy delete current user is contractor date is not in month' do
    current_user_id = 2
    user = User.find(current_user_id)
    currDate = DateTime.parse '2013-09-01 00:00:00'
    sign_in user
    busToDel = Busyness.find(2)
    delete :destroy, {:user_id => current_user_id, :id =>  busToDel.id, :curr_date => currDate, :format => :json}
    assert_response :unprocessable_entity
  end

end