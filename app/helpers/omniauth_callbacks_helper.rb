module OmniauthCallbacksHelper
	def routesFurther

		if @user.persisted?
			sign_in_and_redirect @user, :event => :authentication
		else
			session['devise.omniauth_data'] = @user
			redirect_to "/users/get_info"
		end
	end
end