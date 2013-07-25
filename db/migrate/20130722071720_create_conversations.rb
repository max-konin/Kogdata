class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :theme
      t.string :hash_string

      t.timestamps
    end
  end
end
