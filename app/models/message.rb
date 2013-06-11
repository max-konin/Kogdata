class Message < ActiveRecord::Base
  attr_accessible :body,  :was_seen
  belongs_to :user, :class_name => 'User', :foreign_key => 'sent_message_id'
  belongs_to :user, :class_name => 'User', :foreign_key => 'received_messages_id'

end
