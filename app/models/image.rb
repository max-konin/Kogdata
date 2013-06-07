class Image < ActiveRecord::Base
	belongs_to :user

	attr_accessible :name, :src
	has_attached_file :src,
		:styles => { :small => "200x200", :thumb => "50x50", :original => "1600x1200" },
		:default_url => "http://placekitten.com/50/50",
		:path => ":rails_root/public/system/:style/:filename",
		:url => ":style/:filename"
end
