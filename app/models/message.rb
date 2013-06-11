class Message < ActiveRecord::Base
  attr_accessible :body,  :was_seen
  belongs_to :recipient, :class_name => 'User'
  belongs_to :sender, :class_name => 'User'

end
