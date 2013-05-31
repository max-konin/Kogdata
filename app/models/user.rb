class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :token_authenticatable, :confirmable,
	# :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
			:recoverable, :rememberable, :trackable, :validatable,
			:omniauthable, :omniauth_providers => [ :facebook, :vkontakte, :twitter, :gplus, :google_oauth2, :devianart ]

	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password, :remember_me, :name, :provider, :uid, :role
	has_many :images, :event

	def get_image_by_name(name)
		Image.find(name)
	end
	
	before_save :set_default_role

	def set_default_role
		self.role ||= :client
	end

	ROLES = %w[admin client contractor banned]

	#check user's role
	def role? (role)
		self.role.eql?(role)
	end
end
