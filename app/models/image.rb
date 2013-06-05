class Image < ActiveRecord::Base
	belongs_to :user

	attr_accessible :name, :image
	has_attached_file :image,
		:styles => { :small => "200x200", :thumb => "50x50", :original => "1600x1200" },
		:path => ":rails_root/public/system/:style/:filename",
		:url => ":style/:filename"
end
