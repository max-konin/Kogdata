class CreateConversationsUsers < ActiveRecord::Migration
  def change
    create_table :conversations_users, :id => false do |t|
      t.references :conversation
      t.references :user
    end
    add_index :conversations_users, [:conversation_id, :user_id]
    add_index :conversations_users, :user_id
  end
end