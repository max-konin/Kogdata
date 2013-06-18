class Conversation < ActiveRecord::Base
  attr_accessible :theme, :hash_string
  has_and_belongs_to_many :users
  has_many :messages

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
end
