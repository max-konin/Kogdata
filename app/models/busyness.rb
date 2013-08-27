class Busyness < ActiveRecord::Base
	belongs_to :user
	attr_accessible :date

	validate :date, :presence => true

  scope :between, ->(start_date, end_date) {Busyness.where("date >= ? AND date <= ? ", start_date, end_date)}

end
