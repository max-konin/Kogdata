class AddAttachmentImageToImages < ActiveRecord::Migration
  def self.up
    change_table :images do |t|
      t.attachment :src
    end
  end

  def self.down
    drop_attached_file :images, :src
  end
end
