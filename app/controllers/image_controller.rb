class ImageController < ApplicationController
	before_filter :authenticate_user!

	def bind
		images = params[:images]
		images.each do |image|
			current_user.images.create :src => image, :name => image.original_filename
		end
		redirect_to "/users/edit"
	end

	def delete
		image_id = params[:id]
		current_user.images.find(image_id).delete
		redirect_to "/users/edit"
	end
end
