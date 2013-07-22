class CreateBusynesses < ActiveRecord::Migration
  def change
    create_table :busynesses do |t|
      t.text :desc
      t.datetime :end
      t.datetime :start
      t.references :user

      t.timestamps
    end 
  end
end
