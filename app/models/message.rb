class Message < ActiveRecord::Base
  attr_accessible :body,  :was_seen
  belongs_to :recipient
  belongs_to :sender

end
