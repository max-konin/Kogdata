class Event < ActiveRecord::Base
  belongs_to :user
  attr_accessible :title, :start, :description
end
