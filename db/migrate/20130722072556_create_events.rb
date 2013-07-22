class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :start
      t.text :description
      t.boolean :closed
      t.string :type
      t.string :location
      t.datetime :end
      t.integer :price
      t.string :status

      t.timestamps
    end
  end
end
