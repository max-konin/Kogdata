class Provider < ActiveRecord::Base
  attr_accessible :uid, :soc_net_name
  belongs_to :user
end