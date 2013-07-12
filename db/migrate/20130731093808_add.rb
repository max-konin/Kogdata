class Add < ActiveRecord::Migration
  def change
    add_column :users, :prise, :integer
  end
end
