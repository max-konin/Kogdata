class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :user_recipient_id
      t.integer :user_sender_id
      t.boolean :was_seen

      t.timestamps
    end
  end
end
