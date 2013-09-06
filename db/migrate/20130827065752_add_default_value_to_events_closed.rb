class AddDefaultValueToEventsClosed < ActiveRecord::Migration
  def change
    change_column_default :events, :closed, false
  end
end
