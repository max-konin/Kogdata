class Message < ActiveRecord::Base
  attr_accessible :body, :was_seen
  belongs_to :conversation
  belongs_to :user

  def self.cut_body!
    if (self.body.to_s.length >= 121)
      self.body = self.body.str[0,119]
    end
  end
end
