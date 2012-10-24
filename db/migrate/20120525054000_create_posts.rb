class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.column :post_type, :string, :null => false, :default => 'link'
      t.column :title, :string, :null => false
      t.column :slug, :string, :null => false
      t.column :published_at, :timestamp, :default => nil
      t.timestamps
      t.column :body, :text
    end
  end
end
