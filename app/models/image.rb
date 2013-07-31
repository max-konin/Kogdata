class Image < ActiveRecord::Base
	before_create :set_file_name
	belongs_to :user

	attr_accessible :name, :src
	has_attached_file :src,
		:styles => {
			:thumb => ["50x50#", :png],
			:small => ["400x300#", :png],
			:original => ["1600x1200#", :png]
		},
		:convert_options => {
			:small => ' -interlace Line',
			:original => ' -interlace Line'
		},
		:default_url => "/system/:style/default_image.png",
		:path => ":rails_root/public/system/:style/:filename",
		:url => "/system/:style/:filename"

	def set_file_name
		begin
			name = SecureRandom.uuid
		end while not Image.where(:src_file_name => name).empty?
		self.src.instance_write :file_name, "_#{name}"
	end
end
