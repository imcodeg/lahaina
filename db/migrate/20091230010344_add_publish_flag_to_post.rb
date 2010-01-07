class AddPublishFlagToPost < ActiveRecord::Migration
  def self.up
    add_column :posts,"is_published",:boolean
  end

  def self.down
    remove_column :posts,"is_published"
  end
end
