class DeleteUserProviderUid < ActiveRecord::Migration
  def change
    remove_column :users, :provider, :uid
  end
end
