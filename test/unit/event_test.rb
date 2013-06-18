require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

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

end
