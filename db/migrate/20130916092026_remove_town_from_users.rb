class RemoveTownFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :town
  end

  def down
    add_column :users, :town, :string
  end
end
