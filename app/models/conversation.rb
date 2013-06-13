class Conversation < ActiveRecord::Base
  attr_accessible :theme
  has_and_belongs_to_many :users
  has_many :messages
end
