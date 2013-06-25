require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  test 'load' do
    conv = Conversation.find 1
    assert conv.users.count == 2
  end

  test 'find_or_create_conversation'  do
    conv = Conversation.find_or_create_by_users [1, 2]
    assert conv.id == 1
    conv = Conversation.find_or_create_by_users [1, 3]
    assert conv.id != 1
  end
end