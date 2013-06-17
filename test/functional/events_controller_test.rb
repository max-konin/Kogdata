require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test 'get index' do
    get :index, {:user_id => 1}
    assert true
  end


end