class UserFactory < ActiveRecord::Base

	def self.createUserByTwitter(oauthInfo)
		@forDebug = oauthInfo
	end

end
