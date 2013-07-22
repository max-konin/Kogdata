class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.integer :uid, :limit => 8
      t.string :soc_net_name
		t.references :user

      t.timestamps
    end
  end
end
