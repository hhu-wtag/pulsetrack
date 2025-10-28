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

ActiveRecord::Schema[8.0].define(version: 2025_10_21_195115) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "check_results", force: :cascade do |t|
    t.bigint "monitored_site_id", null: false
    t.integer "status"
    t.integer "http_status_code"
    t.integer "response_time_ms"
    t.text "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_check_results_on_created_at"
    t.index ["monitored_site_id"], name: "index_check_results_on_monitored_site_id"
  end

  create_table "monitored_sites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "url", null: false
    t.integer "check_frequency_seconds", default: 300
    t.integer "last_status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "next_check_at", default: -> { "CURRENT_TIMESTAMP" }
    t.index ["next_check_at"], name: "index_monitored_sites_on_next_check_at"
    t.index ["user_id"], name: "index_monitored_sites_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "notifiable_type", null: false
    t.bigint "notifiable_id", null: false
    t.text "message", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "check_results", "monitored_sites"
  add_foreign_key "monitored_sites", "users"
  add_foreign_key "notifications", "users"
end
