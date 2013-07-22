class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable,
	# :lockable, :timeoutable
	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :token_authenticatable, :omniauth_providers => [ :facebook, :vkontakte, :twitter, :gplus, :google_oauth2, :devianart ]

	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password, :remember_me, :name, :role, :images, :avatar, :avatar_url, :price


	has_attached_file :avatar, 
							:styles => {
								:small => ["300x300#", :png],
								:thumb => ["50x50#", :png],
								:original => ["1600x1200#", :png]
							},
							:default_url => "/avatars/:style/default_avatar.png",
							:path => ":rails_root/public/avatars/:style/:filename",
							:url => "/avatars/:style/:filename"

	has_many :images, :dependent => :destroy
	has_many :event, :dependent => :destroy
	has_and_belongs_to_many :conversations
	has_many :messages
	has_many :provider, :dependent => :destroy
	has_many :social_links, :dependent => :destroy
	has_many :busyness, :dependent => :destroy

	after_initialize :set_default_role
	after_save :set_default_name
	after_save :remove_price_4_client
	before_save :download_avatar, :if => :avatar_url_provided?

	ROLES = %w[admin client contractor banned]
	validates :price, :presence => true, :numericality => {:only_integer => true}, :if => :is_contractor?

	#check user's role
	def role? (role)
		self.role.to_sym == role.to_sym
	end

	def active_for_authentication?
		true
	end

	private

	def is_contractor?
		role == :contractor
	end

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

	def avatar_url_provided?
		!self.avatar_url.blank?
	end

	def download_avatar
		self.avatar = get_image
		self.avatar_url = ""
	rescue
		puts "Error while download."
	end

	def get_image
		img = open(URI.parse(self.avatar_url))
		img.base_uri.path.split("/").last.blank? ? nil : img
  end

  before_validation do
    self.name = self.name.strip
    self.email = self.email.strip
  end
end
