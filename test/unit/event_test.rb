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


  test 'description should not be blank'do
    event = Event.new()
    event.valid?
    assert event.errors.messages[:description].any?
  end

  test 'start should not be blank'do
    event = Event.new()
    event.valid?
    assert event.errors.messages[:start].any?
  end

  test 'end should not be blank'do
    event = Event.new()
    event.valid?
    assert event.errors.messages[:end].any?
  end

  test 'type should not be blank'do
    event = Event.new()
    event.valid?
    assert event.errors.messages[:type].any?
  end

  test 'city_id should not be blank'do
    event = Event.new()
    event.valid?
    assert event.errors.messages[:city_id].any?
  end


  test 'save' do
    event = Event.new()
    event.description = 'description'
    event.start = Time.now
    event.end = Time.now
    event.location = 'karaganda'
    event.type = 'marridge'
    assert event.save
  end

  test 'validate closed' do
    event = Event.new()
    event.description = 'description'
    event.start = Time.now
    event.end = Time.now
    event.location = 'karaganda'
    event.type = 'marridge'
    event.closed = false
    event.valid?
    assert_blank event.errors.messages[:closed]
    event = Event.new()
    event.closed = 'not closed'
    event.closed = true
    event.valid?
    assert_blank event.errors.messages[:closed]
  end

end
