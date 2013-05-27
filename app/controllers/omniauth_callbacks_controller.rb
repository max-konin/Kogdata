class OmniauthCallbacksController < ApplicationController
	def index
		@user = User.find_by_oauth(request.env['omniauth.auth'], current_user, params[:provider])
		
		if @user.persisted?
			sign_in_and_redirect @user, :event => :authentication
		else
			session["devise.user_data"] = request.env['omniauth.auth']
			redirect_to "/users"
		end
	end
end
