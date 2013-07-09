class SocialLink < ActiveRecord::Base
  attr_accessible :provider, :url, :description
  validates :url, :presence => true,:format => {:with => /\Ahttps?:\/\/(\w+.)?\w+.\w+(.\w+)?(\/\w+)+\/?\z/}, :length => {:maximum => 255}
  belongs_to :user

  def get_provider(url)
    url.scan(/\Ahttps?:\/\/(?:\w+.)\w+.\w+(.\w+)?(\/\w+)+\/?\z/)
  end
end
