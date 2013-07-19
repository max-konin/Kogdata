class CreateBusynesses < ActiveRecord::Migration
  def change
    create_table :busynesses do |t|
      t.date :start
      t.date :end
      t.string :desc

      t.timestamps
    end
  end
end
