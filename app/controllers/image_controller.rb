class ImageController < ApplicationController
	before_filter :authenticate_user!

	def bind
		debugger
		#current_user.images.destroy_all()
		images = params[:images]
		userId = current_user.id
		images.each do |name, image| 
			current_user.images.create :image => image, :name => image.original_filename
		end
		redirect_to "/users/edit"
	end
end
