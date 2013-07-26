class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	include OmniauthCallbacksHelper

	def twitter
		oauth = request.env['omniauth.auth']
		@provider = Provider.where(:soc_net_name => oauth.provider, :uid => oauth.uid).first
    if @provider
      @user = User.find(@provider.user_id)
		else
      @user = User.new
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
		oauth = request.env['omniauth.auth']
    @provider = Provider.where(:soc_net_name => oauth.provider, :uid => oauth.uid).first
    if @provider
      @user = User.find(@provider.user_id)
    else
      @user = User.new
      @provider = Provider.new
      @provider.soc_net_name = oauth.provider
      @provider.uid = oauth.uid
      @user.password = Devise.friendly_token[0,20]
    end
		routesFurther
	end
end
