class Event < ActiveRecord::Base
  belongs_to :user
  attr_accessible :start, :description, :closed, :type, :location, :duration, :price, :status
  validates :start, :duration, :description, :type, :location, :presence => true
  validates :closed, :inclusion => {:in => [true, nil]}
  validate :type, :inclusion => {:in => %w(marridge birthday other)}
  validate :status, :inclusion => {:in => %w(open closed in_progress)}
  has_many :messages
end
