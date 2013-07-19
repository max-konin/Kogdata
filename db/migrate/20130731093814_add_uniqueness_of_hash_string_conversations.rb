class AddUniquenessOfHashStringConversations < ActiveRecord::Migration
  def change
    change_column :conversations, :hash_string, :string, :unique => true
  end

end
