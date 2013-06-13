class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.timestamps
      t.string :theme
    end
  end
end
