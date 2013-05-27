class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :token_authenticatable, :confirmable,
	# :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
			:recoverable, :rememberable, :trackable, :validatable,
			:omniauthable, :omniauth_providers => [:facebook, :vkontakte, :twitter, :gplus, :google_oauth2, :devianart]

	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password, :remember_me, :name, :provider, :uid

	def find_by_oauth(auth, signedInResource = nil, provider)
		user = User.where(:provider => auth.provider, :uid => auth.uid)
		unless user
			UserFactory.createUserBy :provider
		end
		user
	end
end
