# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_07_02_171940) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "catch_rates", force: :cascade do |t|
    t.bigint "water_bioresource_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "length_dnipro", precision: 3, scale: 1
    t.decimal "length_other", precision: 3, scale: 1
    t.decimal "length_black", precision: 3, scale: 1
    t.decimal "length_azov", precision: 3, scale: 1
    t.index ["water_bioresource_id"], name: "index_catch_rates_on_water_bioresource_id"
  end

  create_table "catches", force: :cascade do |t|
    t.datetime "catch_time"
    t.decimal "catch_length", precision: 4, scale: 1, default: "0.0"
    t.decimal "catch_weight", precision: 5, scale: 3, default: "0.0"
    t.integer "catch_result"
    t.bigint "fishing_session_id", null: false
    t.bigint "water_bioresource_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fishing_session_id"], name: "index_catches_on_fishing_session_id"
    t.index ["water_bioresource_id"], name: "index_catches_on_water_bioresource_id"
  end

  create_table "day_rates", force: :cascade do |t|
    t.decimal "catch_amount", precision: 3, scale: 1, default: "0.0"
    t.integer "amount_type"
    t.bigint "water_bioresource_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["water_bioresource_id"], name: "index_day_rates_on_water_bioresource_id"
  end

  create_table "fishing_places", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "where_catch"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_fishing_places_on_user_id"
  end

  create_table "fishing_sessions", force: :cascade do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.bigint "user_id", null: false
    t.bigint "fishing_place_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fishing_place_id"], name: "index_fishing_sessions_on_fishing_place_id"
    t.index ["user_id"], name: "index_fishing_sessions_on_user_id"
  end

  create_table "news_stories", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_news_stories_on_user_id"
  end

  create_table "rate_penalties", force: :cascade do |t|
    t.bigint "water_bioresource_id", null: false
    t.integer "money"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["water_bioresource_id"], name: "index_rate_penalties_on_water_bioresource_id"
  end

  create_table "tool_catches", force: :cascade do |t|
    t.bigint "tool_id", null: false
    t.bigint "catch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["catch_id"], name: "index_tool_catches_on_catch_id"
    t.index ["tool_id"], name: "index_tool_catches_on_tool_id"
  end

  create_table "tools", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tool_type"
    t.index ["user_id"], name: "index_tools_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "water_bioresources", force: :cascade do |t|
    t.string "name"
    t.string "latin_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "resource_type"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "catch_rates", "water_bioresources"
  add_foreign_key "catches", "fishing_sessions"
  add_foreign_key "catches", "water_bioresources"
  add_foreign_key "day_rates", "water_bioresources"
  add_foreign_key "fishing_places", "users"
  add_foreign_key "fishing_sessions", "fishing_places"
  add_foreign_key "fishing_sessions", "users"
  add_foreign_key "news_stories", "users"
  add_foreign_key "rate_penalties", "water_bioresources"
  add_foreign_key "tool_catches", "catches"
  add_foreign_key "tool_catches", "tools"
  add_foreign_key "tools", "users"
end
