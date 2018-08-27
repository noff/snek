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

ActiveRecord::Schema.define(version: 2018_08_13_132803) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties_jsonb_path_ops", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "arenas", force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "area", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "battle_rounds", force: :cascade do |t|
    t.integer "battle_id"
    t.integer "round_number"
    t.jsonb "arena"
    t.jsonb "sneks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_id"], name: "index_battle_rounds_on_battle_id"
  end

  create_table "battles", force: :cascade do |t|
    t.string "aasm_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fail_reason"
    t.integer "initiator_snek_id"
    t.integer "arena_id", default: 1
    t.integer "mode", default: 0
    t.bigint "visit_id"
    t.index ["aasm_state"], name: "index_battles_on_aasm_state"
    t.index ["arena_id"], name: "index_battles_on_arena_id"
    t.index ["initiator_snek_id"], name: "index_battles_on_initiator_snek_id"
    t.index ["mode"], name: "index_battles_on_mode"
    t.index ["visit_id"], name: "index_battles_on_visit_id"
  end

  create_table "daily_ratings", force: :cascade do |t|
    t.integer "snek_id"
    t.date "date"
    t.integer "activity_position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "activity_score", default: 0
    t.integer "efficiency_position"
    t.decimal "efficiency_score", default: "0.0"
    t.index ["date"], name: "index_daily_ratings_on_date"
    t.index ["snek_id", "date"], name: "index_daily_ratings_on_snek_id_and_date", unique: true
    t.index ["snek_id"], name: "index_daily_ratings_on_snek_id"
  end

  create_table "paid_subscriptions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "amount"
    t.date "paid_till"
    t.boolean "renewable", default: true
    t.string "stripe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "product"
  end

  create_table "saved_battles", force: :cascade do |t|
    t.integer "battle_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "battle_id"], name: "index_saved_battles_on_user_id_and_battle_id", unique: true
    t.index ["user_id"], name: "index_saved_battles_on_user_id"
  end

  create_table "snek_battles", force: :cascade do |t|
    t.integer "snek_id"
    t.integer "battle_id"
    t.integer "score", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_id"], name: "index_snek_battles_on_battle_id"
    t.index ["snek_id", "score"], name: "index_snek_battles_on_snek_id_and_score"
    t.index ["snek_id"], name: "index_snek_battles_on_snek_id"
  end

  create_table "sneks", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "rules"
    t.boolean "auto_fight", default: false
    t.string "color"
    t.string "pattern"
    t.string "pattern_color"
    t.integer "current_battles_count", default: 0
    t.boolean "pro", default: false
    t.bigint "visit_id"
    t.string "country"
    t.boolean "active", default: true
    t.index ["user_id"], name: "index_sneks_on_user_id"
    t.index ["visit_id"], name: "index_sneks_on_visit_id"
  end

  create_table "subscription_payments", force: :cascade do |t|
    t.integer "paid_subscription_id"
    t.integer "user_id"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "crowns", default: 0
    t.string "stripe_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
