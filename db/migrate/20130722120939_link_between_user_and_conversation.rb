class LinkBetweenUserAndConversation < ActiveRecord::Migration
	def up
		create_table :user_link_conversation, :id => false do |t|
			t.references :user
			t.references :conversation
		end

		add_index :user_link_conversation, [:user_id, :conversation_id]
	end

	def down
		drop_table :user_link_conversation
	end
end
