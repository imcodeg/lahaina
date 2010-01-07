class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :slug
      t.string :title
      t.date :published_at
      t.string :excerpt
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
