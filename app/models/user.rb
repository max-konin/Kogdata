class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :token_authenticatable, :confirmable,
	# :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
			:recoverable, :rememberable, :trackable, :validatable,
			:omniauthable, :omniauth_providers => [:facebook, :vkontakte, :twitter, :gplus, :google_oauth2, :devianart]
  #Reference with events
  has_many :event
	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password, :remember_me, :name, :provider, :uid, :role

  after_initialize :set_default_role

  def set_default_role
    self.role ||= :client
  end

  ROLES = %w[admin client contractor banned]

  #check user's role
  def role? (role)
    self.role.eql?(role)
  end
end
