class Image < ActiveRecord::Base
	before_create :set_file_name
	belongs_to :user

	attr_accessible :name, :src
	has_attached_file :src,
				:styles => { 
					:thumb => ["50x50#", :png],
					:small => ["90x90#", :png],
					:original => ["1600x1200#", :png] 
				},
				:default_url => "/system/:style/default_image.png",
				:path => ":rails_root/public/system/:style/:filename",
				:url => "/system/:style/:filename"

	def set_file_name
		debugger
		name = SecureRandom.uuid
		while not Image.where(:src_file_name => name).empty?
			name = SecureRandom.uuid
		end
		self.src.instance_write :file_name, "_#{name}"
	end
end
