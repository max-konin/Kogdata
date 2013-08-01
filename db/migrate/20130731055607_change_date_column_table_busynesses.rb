class ChangeDateColumnTableBusynesses < ActiveRecord::Migration
  def change
     change_column :busynesses, :date, :date
  end
end
