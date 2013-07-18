class SocialLink < ActiveRecord::Base
  attr_accessible :provider, :url, :description
  validates_uniqueness_of :url
  # If change reg expr in this file, change expr in file /app/assets/javascripts/social_link.js.coffee and helper social_link
  validates :url, :presence => true,:format => {:with => /\Ahttps?:\/\/([\w-]+\.)?[\w-]+\.\w+(\.\w+)?(\/\w+)*\/?\z/}, :length => {:maximum => 255}
  validates :description, :format => {:with => /\A[\w\u0410-\u044F\u0451\u0401 \-+#,\.')(]+\z/}, :length => {:maximum => 40}
  belongs_to :user
end
