class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable,
	# :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :recoverable,	:rememberable, :trackable,	:validatable, :omniauthable, :token_authenticatable, :omniauth_providers => [ :facebook, :vkontakte, :twitter, :gplus, :google_oauth2, :devianart ]

	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password, :remember_me, :name, :provider, :uid, :role, :images
	has_many :images
	has_many :event
  has_and_belongs_to_many :conversations
  has_many :messages

	def get_image_by_name(name)
		Image.find(name)
	end

  after_create :set_default_role
  after_save :set_default_name

  def set_default_name
    if (self.name.nil?) || (self.name.empty?) then
      self.name = "user" + self.id.to_s
      self.save
    end
  end

	def set_default_role
		self.role ||= :client
	end

	ROLES = %w[admin client contractor banned]

	#check user's role
	def role? (role)
		self.role.to_sym == role.to_sym
	end
end
