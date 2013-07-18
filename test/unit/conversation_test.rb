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

  test 'validate uniqueness of hash_string' do
    conv1 = Conversation.new
    conv1.hash_string = '5 9 '
    assert conv1.save!
    conv2 = Conversation.new
    conv2.hash_string = '5 9 '
    assert !conv2.valid?
    assert !conv2.save!
  end

end