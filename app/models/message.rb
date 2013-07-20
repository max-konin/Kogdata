class Message < ActiveRecord::Base
  attr_accessible :body, :was_seen
  belongs_to :conversation
  belongs_to :user
  belongs_to :event

end

