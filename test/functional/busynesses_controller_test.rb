require 'test_helper'

class BusynessesControllerTest < ActionController::TestCase

  test 'get index' do
    current_user_id = 2
    user = User.find(current_user_id)
    currDate = Date.new 2013-07-01
    startDate
    sign_in user
    bysEtalon = user.busynesses.where(:date >= 2013-07-01, :date <= 2013-07-31)
    puts  bysEtalon
    get :index, {:user_id => current_user_id, :curr_date => currDate}


  end

  test 'put create' do

  end

  test 'destroy delete' do

  end

end