class CreateTableProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.integer :uid, :limit => 8
      t.string :soc_net_name
      t.references :user
    end
    add_index :providers, :user_id
  end
end
