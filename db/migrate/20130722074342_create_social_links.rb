class CreateSocialLinks < ActiveRecord::Migration
  def change
    create_table :social_links do |t|
      t.string :provider
      t.string :url
      t.text :description
		t.references :user

      t.timestamps
    end
  end
end
