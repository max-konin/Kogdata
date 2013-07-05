require 'test_helper'
require 'messages_helper'

class MessagesHelperTest <  ActiveSupport::TestCase
  include MessagesHelper
  test 'new response for event' do
    message = new_response_for_event 1
    assert !message.nil?
    assert message.event.id == 1
  end
end
