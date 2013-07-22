class UpdateSocialLink < ActiveRecord::Migration
  def change
    remove_column :social_links, :description
    remove_index :social_links, :url
    add_index(:social_links, [:provider, :url], unique: true, name: 'index_provider_url')
  end
end
