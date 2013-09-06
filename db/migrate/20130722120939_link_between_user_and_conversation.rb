class LinkBetweenUserAndConversation < ActiveRecord::Migration
	def up
		create_table :conversations_users, :id => false do |t|
			t.references :user
			t.references :conversation
		end

		add_index :conversations_users, [:user_id, :conversation_id]
	end

	def down
		drop_table :conversations_users
	end
end
