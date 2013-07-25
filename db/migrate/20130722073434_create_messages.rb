class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.boolean :was_seen
		t.references :user
		t.references :conversation
		t.references :event

      t.timestamps
    end
  end
end
