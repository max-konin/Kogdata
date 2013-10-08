class SocialLink < ActiveRecord::Base
  attr_accessible :provider, :url
	validates_uniqueness_of :url
  validates :url, :presence => true, :format => {:with => /\A[\w-]+\z/}, :length => {:maximum => 24}

	PROVIDERS = %w(vkontakte twitter facebook gplus) # If change -> update /app/helpers/social_link_helper.rb
	validates :provider, :presence => true, :inclusion =>{:in => PROVIDERS}

	belongs_to :user
end
