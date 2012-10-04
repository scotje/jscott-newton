class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.column :title, :string, :null => false
      t.column :slug, :string, :null => false
      t.column :published_at, :timestamp, :default => nil
      t.timestamps
      t.column :body, :text
    end
  end
end
