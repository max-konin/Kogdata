class Image < ActiveRecord::Base
	belongs_to :user

	attr_accessible :name, :image
	has_attached_file :image,
		:styles => { :small => "150x160", :thumb => "50x50", :original => "1600x1200" },
		:default_url => "http://placekitten.com/50/50",
		:path => ":rails_root/public/system/:style/:filename",
		:url => "/system/:style/:filename"
end
