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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_26_004132) do

  create_table "summaries", force: :cascade do |t|
    t.string "name"
    t.string "uuid", null: false
    t.date "start_at"
    t.date "end_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_summaries_on_uuid", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.integer "summary_id"
    t.string "name"
    t.integer "messages_count", default: 0
    t.integer "kusas_count", default: 0
    t.integer "stamps_count", default: 0
    t.integer "photos_count", default: 0
    t.date "start_at"
    t.date "end_at"
    t.text "message_count_per_hour"
    t.index ["summary_id"], name: "index_users_on_summary_id"
  end

end
