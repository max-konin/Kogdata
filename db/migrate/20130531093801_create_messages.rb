class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.references :user
      t.references :conversation
      t.boolean :was_seen

      t.timestamps
    end
  end
end
