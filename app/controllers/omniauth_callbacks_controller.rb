class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	include OmniauthCallbacksHelper

	def twitter
		oauth = request.env['omniauth.auth']
		@provider = Provider.where(:soc_net_name => oauth.provider, :uid => oauth.uid).first
		unless @provider
      if user_signed_in?
        @user = currunt_user
      else
        @user = User.new
      end
			@provider = Provider.new
			@provider.soc_net_name = oauth.provider
			@provider.uid = oauth.uid
			@user.password = Devise.friendly_token[0,20]
		end
		routesFurther
	end

	def facebook
		oauth = request.env['omniauth.auth']
		@provider = Provider.where(:provider => oauth.provider, :uid => oauth.uid).first
		unless @provider
			@user = User.new
			@user.email = oauth.info.email
			@user.provider = oauth.provider
			@user.uid = oauth.uid
			@user.password = Devise.friendly_token[0,20]
		end
		routesFurther
	end

	def vkontakte
		oauth = request.env['omniauth.auth']
		@user = User.where(:provider => oauth.provider, :uid => oauth.uid).first
		unless @user
			@user = User.new
			@user.provider = oauth.provider
			@user.uid = oauth.uid
			@user.password = Devise.friendly_token[0,20]
		end
		routesFurther
	end
end
