class ImageController < ApplicationController
	before_filter :authenticate_user!

	def bind
		debugger
		images = params[:images]
		userId = current_user.id
		images.count.times do current_user.images.build end
		images.each do |image|
			image = Image.create(image)
			image.user_id = userId
		end
		redirect_to "users/edit"
	end
end
