class AddPrice < ActiveRecord::Migration
  def change
    remove_column :users, :prise
    add_column :users, :price, :integer
  end
end
