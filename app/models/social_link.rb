class SocialLink < ActiveRecord::Base
  attr_accessible :provider, :url, :description
  validates_uniqueness_of :url
  validates :url, :presence => true,:format => {:with => /\A[\w-]+\z/}, :length => {:maximum => 255}
  belongs_to :user
end
