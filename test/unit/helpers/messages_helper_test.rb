require 'test_helper'
require 'messages_helper'

class MessagesHelperTest <  ActiveSupport::TestCase
  include MessagesHelper
  def current_user
    users(:Mitya)
  end
  test 'count unread messages' do
    message = count_unread_messages
    assert_equal message, '(2)'
  end
end
