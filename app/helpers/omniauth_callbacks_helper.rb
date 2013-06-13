module OmniauthCallbacksHelper
	def routesFurther
		if @user.persisted?
			sign_in_and_redirect @user, :event => :authentication
		else
			sign_in @user
			redirect_to "/users/sign_in"
		end
	end
end
