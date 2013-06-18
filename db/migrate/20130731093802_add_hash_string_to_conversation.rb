class AddHashStringToConversation < ActiveRecord::Migration
  def change
    add_column :conversations, :hash_string, :string
  end
end
