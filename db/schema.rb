# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120925224128) do

  create_table "pages", :force => true do |t|
    t.string   "title",        :null => false
    t.string   "slug",         :null => false
    t.datetime "published_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "body"
  end

  create_table "posts", :force => true do |t|
    t.string   "post_type",    :default => "link", :null => false
    t.string   "title",                            :null => false
    t.string   "slug",                             :null => false
    t.datetime "published_at"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.text     "body"
  end

  create_table "settings", :force => true do |t|
    t.string  "key",                          :null => false
    t.string  "type",   :default => "string", :null => false
    t.string  "value"
    t.boolean "system", :default => false,    :null => false
  end

  add_index "settings", ["key"], :name => "index_settings_on_key", :unique => true

  create_table "short_links", :force => true do |t|
    t.string "short_code", :null => false
    t.string "url",        :null => false
  end

  add_index "short_links", ["short_code"], :name => "index_short_links_on_short_code", :unique => true

end
