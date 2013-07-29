class CreateBusynesses < ActiveRecord::Migration
  def change
    create_table :busynesses do |t|
      t.datetime :date
      t.references :user

      t.timestamps
    end 
  end
end
