class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :key, :null => false
      t.string :setting_type, :null => false, :default => 'string'
      t.string :value
      t.boolean :system, :null => false, :default => false
    end
    
    add_index :settings, :key, :unique => true
  end
end
