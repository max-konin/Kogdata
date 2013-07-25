class Event < ActiveRecord::Base
  belongs_to :user
	has_many :responses
  attr_accessible :start,:finish, :description, :closed, :type, :location,  :price, :status
  validates :start, :finish, :duration, :description, :type, :location, :presence => true
  validates :closed, :inclusion => {:in => [true, nil]}
  TYPES = %w(marridge birthday other)
  STATUSES = %w(open closed in_progress)
  validate :type, :inclusion => {:in => TYPES}
  validate :status, :inclusion => {:in => STATUSES}
end
