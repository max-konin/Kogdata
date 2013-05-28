module OmniauthCallbacksHelper
	def routesFurther
		if @user.persisted?
			sign_in_and_redirect @user, :event => :authentication
		else
			sign_in @user
			#session["devise.user_data"] = request.env['omniauth.auth']
			redirect_to "/"
		end
	end
end
