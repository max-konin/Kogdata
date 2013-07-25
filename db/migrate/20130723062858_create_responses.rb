class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :event
      t.references :user
      t.string :status

      t.timestamps
    end
    add_index :responses, :event_id
    add_index :responses, :user_id
		add_index :responses, [:event_id, :user_id], unique: true
  end
end
