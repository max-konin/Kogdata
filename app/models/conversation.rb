class Conversation < ActiveRecord::Base
  attr_accessible :theme, :hash_string, :users
  has_and_belongs_to_many :users
  has_many :messages
  validates :hash_string, :uniqueness => true


  #Force method for find conversation between 2 users
  #Unsafe SQL query!
  #unstable! dont use it!!!
  def self.find_by_2_users user1_id, user2_id
    Conversation.find_by_sql "SELECT * FROM conversations" +
                           " INNER JOIN conversations_users as cu1 ON `conversations`.`id` = cu1.`conversation_id`" +
                           " INNER JOIN conversations_users as cu2 ON `conversations`.`id` = cu1.`conversation_id`" +
                           " WHERE (cu1.user_id = " + user1_id.to_s +
                           ") AND (cu2.user_id = " + user2_id.to_s +
                           ") LIMIT 1"
  end

  def self.find_or_create_by_users users
    raise ArrgumenError, 'Members cannot be empty' if users.empty?
    users.sort!
    hash = String.new
    users.each do |member|
      #makes hash string from accepted ids of declared members and current user id
      hash += (member.to_s + ' ')
    end

    conversation = Conversation.find_by_hash_string(hash)

    if conversation.nil? then
      #creates a new conversation for current user if no matches found
      conversation = Conversation.new
      conversation.hash_string = hash
      users.each do |user|
        conversation.users << User.find(user)
      end
      conversation.save!
    end
    conversation
  end
end
