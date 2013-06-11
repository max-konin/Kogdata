class Message < ActiveRecord::Base
  attr_accessible :body,  :was_seen
  belongs_to :recipient, :class_name => 'User', :foreign_key => 'user_recipient_id'
  belongs_to :sender, :class_name => 'User', :foreign_key => 'user_sender_id'

end
