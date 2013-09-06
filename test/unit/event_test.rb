require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'select opened events' do
    actual_events = Event.opened
    expected_events = Event.where :closed => false
    assert_equal actual_events, expected_events
  end

  test 'select events between days' do
    start_date = DateTime.parse '2013-06-18'
    end_date = DateTime.parse '2013-06-18'
    actual_events = Event.between start_date, end_date
    expected_events = Event.where("start >= ? AND start <= ? ", start_date, end_date)
    assert_equal actual_events, expected_events
  end

  test 'title should not be blank'do
    event = Event.new()
    event.description = 'description'
    event.start = Time.now
    assert !(event.save)
  end

  test 'description should not be blank'do
    event = Event.new()
    event.title = 'title'
    event.start = Time.now
    assert !(event.save)
  end

  test 'start should not be blank'do
    event = Event.new()
    event.title = 'title'
    event.description = 'description'
    assert !(event.save)
  end

  test 'save' do
    event = Event.new()
    event.title = 'title'
    event.description = 'description'
    event.start = Time.now
    assert event.save
  end

  test 'validate closed' do
    event = Event.new()
    event.title = 'title'
    event.description = 'description'
    event.start = Time.now
    event.closed = false
    assert !event.save
    event.closed = 'not closed'
    assert !event.save
    event.closed = true
    assert event.save
    event.closed = nil
    assert event.save
  end

end
