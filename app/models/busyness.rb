class Busyness < ActiveRecord::Base
	belongs_to :user
	attr_accessible :date

	validate :date, :presence => true

end
