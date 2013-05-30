class Message < ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :date
end
