module OmniauthCallbacksHelper
	def routesFurther
		if @user.persisted? && !user_signed_in?
			sign_in_and_redirect @user, :event => :authentication
		else
			session['devise.omniauth_data'] = @user
			session['devise.provider'] = @provider
			redirect_to "/users/get_info"
		end
	end
end