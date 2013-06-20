class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def twitter
		oauth = request.env['omniauth.auth']
		@user = User.where(:provider => oauth.provider, :uid => oauth.uid).first
		unless @user
			@user = User.new
			@user.name = oauth.info.name
			@user.email = oauth.extra.raw_info.screen_name.nil? || oauth.extra.raw_info.screen_name.empty? ? "pretty" : oauth.extra.raw_info.screen_name + "@please.full"
			@user.provider = oauth.provider
			@user.uid = oauth.uid
			@user.password = Devise.friendly_token[0,20]
			@user.save!
		end
		sign_in_and_redirect @user, :event => :authentication
	end

	def facebook
		oauth = request.env['omniauth.auth']
		@user = User.where(:provider => oauth.provider, :uid => oauth.uid).first
		unless @user
			@user = User.new
			@user.name = oauth.info.name
			@user.email = oauth.info.email || "pretty@please.full"
			@user.provider = oauth.provider
			@user.uid = oauth.uid
			@user.password = Devise.friendly_token[0,20]
			@user.save!
		end
		sign_in_and_redirect @user, :event => :authentication
	end

	def vkontakte
		oauth = request.env['omniauth.auth']
		@user = User.where(:provider => oauth.provider, :uid => oauth.uid).first
		unless @user
			@user = User.new
			@user.name = oauth.info.name
			@user.email = oauth.info.nickname.nil? || oauth.info.nickname.empty? ? "pretty" : oauth.info.nickname + "@please.full"
			@user.provider = oauth.provider
			@user.uid = oauth.uid
			@user.password = Devise.friendly_token[0,20]
			@user.save!
		end
		sign_in_and_redirect @user, :event => :authentication
	end
end
