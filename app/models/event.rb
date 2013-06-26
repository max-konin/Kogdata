class Event < ActiveRecord::Base
  belongs_to :user
  attr_accessible :title, :start, :description
  validates :title, :start, :description , :presence => true
  has_many :messages
end
