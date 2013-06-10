class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.references :recipient
      t.references :sender
      t.boolean :was_seen

      t.timestamps
    end
  end
end