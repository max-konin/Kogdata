class Image < ActiveRecord::Base

	belongs_to :user

	attr_accessible :name, :src
	has_attached_file :src,
				:styles => { 
					:thumb => ["35x35", :png],
					:small => ["90x90#", :png],
					:original => ["1600x1200#", :png] 
				},
				:default_url => "/system/:style/default_image.png",
				:path => ":rails_root/public/system/:style/:filename",
				:url => "/system/:style/:filename"

	validate :name, :uniqueness => true
	before_create :set_file_name

	private

	def set_file_name
		begin
			name = SecureRandom.uuid
		end while not Image.where(:src_file_name => name).empty?
		self.src.instance_write :file_name, "_#{name}"
		self.name = name
	end
end
