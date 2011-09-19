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

ActiveRecord::Schema.define(:version => 20110919201412) do

  create_table "page_logs", :force => true do |t|
    t.text     "pager_number"
    t.integer  "virtual_pager_id"
    t.text     "message"
    t.integer  "status"
    t.text     "status_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pagers", :force => true do |t|
    t.text     "pager_number"
    t.integer  "virtual_pager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "virtual_pagers", :force => true do |t|
    t.string   "name"
    t.integer  "min_active"
    t.integer  "max_active"
    t.boolean  "send_alerts"
    t.boolean  "log_messages"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
