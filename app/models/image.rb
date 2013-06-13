class Image < ActiveRecord::Base
	belongs_to :user

	attr_accessible :name, :src
	has_attached_file :src,
		:styles => { :small => ["90x90^", :png], :thumb => ["50x50^", :png], :original => ["1600x1200^", :png] },
		:default_url => "http://placekitten.com/50/50",
		:path => ":rails_root/public/system/:style/:filename",
		:url => "/system/:style/:filename"
end
