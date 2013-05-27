class CreateUserFactories < ActiveRecord::Migration
  def change
    create_table :user_factories do |t|

      t.timestamps
    end
  end
end
