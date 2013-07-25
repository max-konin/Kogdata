class Response < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  attr_accessible :status, :user_id

	STATUSES = %w[submitted rejected confirmed completed]
	validates :status, :presence => true, :inclusion => {:in => STATUSES}
	validates :event_id, :user_id, :presence => true

	after_initialize :set_default_status
end

private

	def set_default_status
		self.status ||= 'submitted'
	end
