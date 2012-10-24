class AddShortLinks < ActiveRecord::Migration
  def change
    create_table :short_links do |t|
      t.column :short_code, :string, :null => false
      t.column :url, :string, :null => false
    end
    
    add_index :short_links, :short_code, :unique => true
  end
end