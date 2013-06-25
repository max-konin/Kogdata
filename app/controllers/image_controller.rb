class ImageController < ApplicationController
	before_filter :authenticate_user!

	def bind
		images = params[:images]
		images.each do |image|
			current_user.images.create :src => image, :name => image.original_filename
		end
		redirect_to "/office/portfolio"
	end

	def delete
		image_id = params[:id]
		current_user.images.find(image_id).destroy
		redirect_to "/office/portfolio"
	end
end
