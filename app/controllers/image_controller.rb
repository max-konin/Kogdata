class ImageController < ApplicationController
	before_filter :authenticate_user!

	def bind
		debugger
		images = params[:user].images
		userId = current_user.id
		images.count.times do current_user.images.build end
		images.each do |image|
			Image.new(image)
		end
		redirect_to "users/edit"
	end
end
