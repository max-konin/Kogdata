class Event < ActiveRecord::Base
  belongs_to :user
  attr_accessible :title, :start, :description, :closed
  validates :title, :start, :description , :presence => true
  validates :closed, :inclusion =>{:in => [true, nil]}
  has_many :messages
end
