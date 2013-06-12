class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :token_authenticatable, :confirmable,
	# :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
			:recoverable, :rememberable, :trackable, :validatable,
			:omniauthable, :omniauth_providers => [ :facebook, :vkontakte, :twitter, :gplus, :google_oauth2, :devianart ]

	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password, :remember_me, :name, :provider, :uid, :role
	has_many :images
	has_many :event
  has_many :received_messages, :class_name => 'Message', :foreign_key => 'user_recipient_id'
  has_many :sent_messages, :class_name => 'Message', :foreign_key => 'user_sender_id'

	def get_image_by_name(name)
		Image.find(name)
	end

  after_initialize :set_default_role

	def set_default_role
		self.role ||= :client
	end

	ROLES = %w[admin client contractor banned]

	#check user's role
	def role? (role)
		self.role.to_sym == role.to_sym
	end
end
