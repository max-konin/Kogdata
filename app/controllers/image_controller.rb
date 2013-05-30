class ImageController < ApplicationController
	before_filter :authenticate_user!

	def select_image
		
	end

	def bind_image
		images = params[:images]
		userId = current_user.id
		images.count.times do current_user.images.build end
		images.each do |image|
			Image.new(image)
		end
	end
end
