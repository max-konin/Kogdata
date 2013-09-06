require 'test_helper'

class BusynessTest < ActiveSupport::TestCase
  test 'select between dates' do
    start_date = DateTime.parse '2013-06-18'
    end_date = DateTime.parse '2013-06-18'
    actual_busyness = Busyness.between start_date, end_date
    expected_busyness = Busyness.where("date >= ? AND date <= ? ", start_date, end_date)
    assert_equal actual_busyness, expected_busyness
  end
end
