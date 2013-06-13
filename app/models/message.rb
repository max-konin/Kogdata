class Message < ActiveRecord::Base
  attr_accessible :body, :was_seen
  belongs_to :conversation
  belongs_to :user

  def cut_body!(msg)
    if (msg.body.to_s.length >= 121)
      msg.body = msg.body.str[0,119]
    end
  end
end
