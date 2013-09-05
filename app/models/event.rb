class Event < ActiveRecord::Base
  after_initialize :set_closed
  belongs_to :user
	has_many :responses
  attr_accessible :start, :end,  :description, :closed, :type, :location,  :price, :status
  set_inheritance_column :ruby_type
  validates :start, :end,  :description, :type, :location, :presence => true
  validates :closed, :inclusion => {:in => [true, false]}
  TYPES = %w(marridge birthday other)
  STATUSES = %w(open closed in_progress)
  validate :type, :inclusion => {:in => TYPES}
  validate :status, :inclusion => {:in => STATUSES }

  scope :opened, -> { where closed: false}
  scope :between, ->(start_date, end_date){ where("start >= ? AND start <= ? ", start_date, end_date) }

  private

  def set_closed
    self.closed ||= false
  end
end
