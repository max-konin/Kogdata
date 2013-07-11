class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable,
	# :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :recoverable,	:rememberable, :trackable,	:validatable,
         :omniauthable, :token_authenticatable,
         :omniauth_providers => [ :facebook, :vkontakte, :twitter, :gplus, :google_oauth2, :devianart ]

	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password, :remember_me, :name, :provider, :uid, :role, :images, :avatar, :price
  validates :price, :presence => true,:numericality => {:only_integer => true}, :if => :is_contractor?
  def is_contractor?
    role == :contractor
  end


	has_attached_file :avatar,
                    :styles => {
                      :small => ["300x300#", :png],
                      :thumb => ["50x50#", :png],
                      :original => ["1600x1200#", :png]
							      },
                    :default_url => "/avatars/:style/default_avatar.png",
                    :path => ":rails_root/public/avatars/:style/:filename",
                    :url => "/avatars/:style/:filename"
	has_many :images
	has_many :event
	has_and_belongs_to_many :conversations
	has_many :messages
  has_many :provider

	def get_image_by_name(name)
		Image.find(name)
	end

  after_initialize :set_default_role
  after_save :set_default_name
  after_save :remove_price_4_client
  def remove_price_4_client
     if self.role == :client
       self.price = nil
     end
  end

  def set_default_name
    if (self.name.nil?) || (self.name.empty?) then
      self.name = "user_" + self.id.to_s
      self.save
    end
  end

	def set_default_role
		self.role ||= "client"
	end

	ROLES = %w[admin client contractor banned]

	#check user's role
	def role? (role)
		self.role.to_sym == role.to_sym
	end
	
	def active_for_authentication?
		true
	end
end
