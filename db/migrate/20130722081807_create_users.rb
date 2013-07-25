class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :role
      t.string :avatar_url
      t.integer :price

      t.timestamps
    end
  end
end
