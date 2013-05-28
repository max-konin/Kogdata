class Image < ActiveRecord::Base
	belongs_to :user

	attr_accessible :name
	has_attached_file :image, 
		:styles => { :small => "200x200" },
		:path => ":rails_root/public/system/:style/:filename"
		:src => "/"
end
