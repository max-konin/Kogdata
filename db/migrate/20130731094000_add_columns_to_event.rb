class AddColumnsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :type, :string
    add_column :events, :location, :string
    add_column :events, :duration, :datetime
    add_column :events, :price, :integer
    add_column :events, :status, :string
  end
end
