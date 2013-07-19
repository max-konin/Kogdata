class AddFinishColumnToEvents < ActiveRecord::Migration
  def change
    add_column :events, :finish, :datetime
  end
end
