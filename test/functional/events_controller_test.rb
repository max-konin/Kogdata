require 'test_helper'

class EventsControllerTest < ActionController::TestCase

  def json
    ActiveSupport::JSON.decode @response.body
  end

  test 'get index in month' do
    currentUser = users :Adarich
    sign_in currentUser
    currentDate = Time.parse '2013-06-18 11:02:57'
    startDate = Time.parse '2013-06-01 00:00:00'
    finishDate = Time.parse '2013-06-30 23:59:59'
    get :index, {:user_id => currentUser.id, :curDate => currentDate}
    assert_response :success
    assert_template :index
    eventsTest = assigns(:events)
    eventsEtalon = Event.where('user_id = ? AND start >= ? AND start <= ? AND closed = false',currentUser.id,
                               startDate, finishDate)
    assert_equal eventsTest.count, eventsEtalon.count
    eventsTest.each do |event|
      assert_equal event.user_id, currentUser.id
      assert (event.start > startDate) && (event.start < finishDate)
    end
  end

  test 'get index' do
    currentUser = users(:Adarich)
    sign_in currentUser
    eventsEtalon = Event.where('user_id = ?',currentUser.id)
    get :index, {:user_id => currentUser.id, :showClosed => true}
    assert_response :success
    assert_template :index
    eventsTest = assigns(:events)
    assert_equal eventsTest.count, eventsEtalon.count
    eventsTest.each do |event|
      assert_equal event.user_id, currentUser.id
    end
  end

  test 'get index with show date' do
    currentUser = users(:Adarich)
    sign_in currentUser
    event_date = Time.parse '2013-06-10 11:00:00'
    event_date_start = Time.parse '2013-06-10 00:00:00'
    event_date_finish = Time.parse '2013-06-10 23:59:59'
    events_in_date = Event.between(event_date_start, event_date_finish)
    get :index, {:user_id => currentUser.id, :show_date => event_date, :format => :json}
    assert_equal json.count, events_in_date.count
  end

  test 'show all' do
    user = users(:Adarich)
    sign_in user
    eventsEtalon = Event.scoped.opened
    get :index, {:user_id => user.id, :show_all => true, :format => :json}
    eventsTest = json
    assert_equal eventsEtalon.count, eventsTest.count
  end

  test 'get new' do
    currentUser = users(:Adarich)
    sign_in currentUser
    assert_raise (NotImplementedError){ get :new, {:user_id => currentUser.id}}
  end

  test 'post create' do
    currentUser = users(:Adarich)
    sign_in currentUser
    currentDate = Time.parse '2013-06-18 11:02:57'
    startDate = Time.parse '2013-06-01 00:00:00'
    finishDate = Time.parse '2013-06-30 23:59:59'
    start4Event = Time.parse '2013-06-25 11:02:57'
    location = 'Karaganda'
    type = 'Marridge'
    price = 100500
    post :create, {:user_id => currentUser.id, :events => {:start=> start4Event, :end => start4Event,
                                                          :description => 'this is a new event', :location => location, :type => type, :price => price},:curDate => currentDate}
    newEvent = Event.last
    start4Event = Time.new '2013-08-25 11:02:57'
    post :create, {:user_id => currentUser.id, :events => {:start=> start4Event, :end => start4Event,
                                                          :description => 'this is a new event', :location => location, :type => type, :price => price},:curDate => currentDate}
    assert_response :bad_request
  end


  test 'get show' do
    currentUser = users(:Adarich)
    sign_in currentUser
    id = 4
    get :show, {:user_id => currentUser.id, :id => id}
    event = assigns(:event)
    eventEtalon = Event.find id
    assert_response :ok
    assert_equal event.id, id
    assert_equal event.start, eventEtalon.start
    assert_equal event.description, eventEtalon.description
  end

  test 'put update' do
    currentUser = users(:Adarich)
    sign_in currentUser
    id = 4
    currentDate = Time.parse '2013-06-18 11:02:57'
    startDate = Time.parse '2013-06-01 00:00:00'
    finishDate = Time.parse '2013-06-30 23:59:59'
    start4Event = Time.parse '2013-06-25 11:02:57'
    location = 'Karaganda'
    type = 'Marridge'
    price = 100500
    put :update, {:user_id => currentUser.id,:id => id, :events => { :start=> start4Event, :end => start4Event,
                                                           :description => 'this is a new event', :location => location, :type => type, :price => price},:curDate => currentDate}
    updatedEvent = Event.find(id)
    assert_response :ok
    assert_equal updatedEvent.description, 'this is a new event'
    start4Event = Time.new '2013-08-25 11:02:57'
    put :update, {:user_id => currentUser.id,:id => id, :events =>  {:start=> start4Event, :end => start4Event,
                                                           :description => 'this is a new event', :location => location, :type => type, :price => price},:curDate => currentDate}
    assert_response :unprocessable_entity
    start4Event = Time.parse '2013-06-25 11:02:57'
    put :update, {:user_id => currentUser.id,:id => 3, :events => {:start=> start4Event, :end => start4Event,
                                                                    :description => 'this is a new event', :location => location, :type => type, :price => price},:curDate => currentDate}
    assert_response :forbidden

  end


  test 'get edit' do
    currentUser = users(:Adarich)
    sign_in currentUser
    assert_raise (NotImplementedError){ get :edit, {:user_id => currentUser.id, :id => 4}}
  end

  test 'delete destroy' do
    currentUser = users(:Adarich)
    sign_in currentUser
    assert_raise (NotImplementedError){ delete :destroy, {:user_id => currentUser.id, :id => 4}}
  end

  test 'put close' do
    currentUser = users(:Adarich)
    sign_in currentUser
    id = 2
    put :close, {:user_id => currentUser.id, :event_id => id}
    assert_response :ok
    assert_equal Event.find(id).closed, true
    put :close, {:user_id => currentUser.id, :event_id => id}
    assert_response :forbidden
    put :reopen, {:user_id => currentUser.id, :event_id => id}
    assert_blank Event.find(id).closed
    put :reopen, {:user_id => currentUser.id, :event_id => id}
    assert_response :forbidden
    put :reopen, {:user_id => currentUser.id, :event_id => 1}
    assert_response :forbidden
  end

  test 'get index for closed events' do
    currentUser = users(:Adarich)
    sign_in currentUser
    currentDate = Time.parse '2013-06-18 11:02:57'
    startDate = Time.parse '2013-06-01 00:00:00'
    finishDate = Time.parse '2013-06-30 23:59:59'
    start4Event = Time.parse '2013-06-25 11:02:57'
    location = 'Karaganda'
    type = 'Marridge'
    price = 100500
    post :create, {:user_id => currentUser.id, :events => {:start=> start4Event, :end => start4Event,
                                                           :description => 'this is a new event', :location => location, :type => type, :price => price},:curDate => currentDate}
    event_id = Event.last.id
    put :close, {:user_id => currentUser.id, :event_id => event_id}
    get :index, {:user_id => currentUser.id, :curDate => currentDate, :showClosed => true}
    event_test = assigns(:events)
    events_etalon = Event.where('user_id = ? AND start > ? AND start < ?',currentUser.id, startDate, finishDate)
    assert_equal event_test.count, events_etalon.count, 'closed included'
    get :index, {:user_id => currentUser.id, :curDate => currentDate}
    event_test = assigns(:events)
    events_etalon = Event.where('user_id = ? AND start > ? AND start < ? AND closed IS false',currentUser.id, startDate, finishDate)
    assert_equal event_test.count, events_etalon.count , 'closed is not included'
  end


end