class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	include OmniauthCallbacksHelper

	def twitter
		oauth = request.env['omniauth.auth']
		@user = User.where(:provider => oauth.provider, :uid => oauth.uid)[0]
		unless @user
			@user = User.new
			@user.name = oauth.info.name
			@user.provider = oauth.provider
			@user.uid = oauth.uid
			@user.password = Devise.friendly_token[0,20]
		end
		routesFurther
	end

	def facebook
		@user
	end

end
