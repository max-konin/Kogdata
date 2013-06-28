module MessagesHelper
  def count_unread_messages
    count = 0
    conversations = current_user.conversations
    conversations.each do |conv|
      count += (conv.messages.where('user_id != ? AND was_seen = ?',current_user.id, false)).count
    end
    (count == 0)? '' : '(' + count.to_s + ')'
  end
end