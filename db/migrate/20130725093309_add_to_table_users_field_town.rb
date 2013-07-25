class AddToTableUsersFieldTown < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :town, :null => false, :default => 'Новосибирск'
    end
  end
end
