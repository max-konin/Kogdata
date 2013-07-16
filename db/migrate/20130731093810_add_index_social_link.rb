class AddIndexSocialLink < ActiveRecord::Migration
  def change
    add_index :social_links, :url, :unique => true
  end
end
