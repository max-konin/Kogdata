class DeleteDurationFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :duration
    add_column :events, :description, :text
  end
end
