class Busyness < ActiveRecord::Base
	belongs_to :user
	attr_accessible :desc, :end, :start

	validate :start, :presence => true
	validate :end, :presence => true
	validate :valid_span

	# return span in days
	def busyness_span
		self.end - self.start
	end
	
	private
	
	def valid_span
		self.start < self.end
	end
end
