class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	include OmniauthCallbacksHelper
	require 'open-uri'

	def twitter
		debugger
		oauth = request.env['omniauth.auth']
		@provider = Provider.where(:soc_net_name => oauth.provider, :uid => oauth.uid).first
		if @provider
			@user = User.find(@provider.user_id)
		else
			@user = User.new
			@provider = Provider.new
			@provider.soc_net_name = oauth.provider
			@provider.uid = oauth.uid
			@user.avatar_url = oauth.extra.raw_info.photo_big
			@user.password = Devise.friendly_token[0,20]
		end
		routesFurther
	end

	def facebook
		debugger
		oauth = request.env['omniauth.auth']
		@provider = Provider.where(:provider => oauth.provider, :uid => oauth.uid).first
		if @provider
			@user = User.find(@provider.user_id)
		else
			@user = User.new
			@user.email = oauth.info.email
			@provider = Provider.new
			@provider.soc_net_name = oauth.provider
			@provider.uid = oauth.uid
			@user.password = Devise.friendly_token[0,20]
		end
		routesFurther
	end

	def vkontakte
		debugger
		oauth = request.env['omniauth.auth']
		@provider = Provider.where(:soc_net_name => oauth.provider, :uid => oauth.uid).first
		if @provider
			@user = User.find(@provider.user_id)
		else
			@user = User.new
			@provider = Provider.new
			@provider.soc_net_name = oauth.provider
			@provider.uid = oauth.uid
			@user.avatar_url = oauth.extra.raw_info.photo_big
			@user.password = Devise.friendly_token[0,20]
		end
		routesFurther
	end
end
