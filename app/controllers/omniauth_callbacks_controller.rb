class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	include OmniauthCallbacksHelper

	def twitter
		oauth = request.env['omniauth.auth']
		@user = User.where(:provider => oauth.provider, :uid => oauth.uid).first
		unless @user
			@user = User.new
			@user.name = oauth.info.name
			@user.email = oauth.extra.raw_info.screen_name + "@please.full"
			@user.provider = oauth.provider
			@user.uid = oauth.uid
			@user.password = Devise.friendly_token[0,20]
			@user.save!
		end
		sign_in_and_redirect @user, :event => :authentication
		#routesFurther
	end

	def facebook
		@user
	end

end
