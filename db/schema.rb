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

ActiveRecord::Schema[8.1].define(version: 2026_02_12_214920) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "applications", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.string "status", default: "pending"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["campaign_id"], name: "index_applications_on_campaign_id"
    t.index ["status"], name: "index_applications_on_status"
    t.index ["user_id", "campaign_id"], name: "index_applications_on_user_id_and_campaign_id"
    t.index ["user_id"], name: "index_applications_on_user_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.boolean "accepting_players", default: true
    t.string "atmosphere"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.integer "required_experience"
    t.string "schedule_json"
    t.string "status", default: "forming"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_campaigns_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.json "availability_json", default: "{}"
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.string "display_name"
    t.string "email", null: false
    t.integer "experience_level", default: 0
    t.string "full_name"
    t.boolean "in_matching_pool", default: true
    t.string "login_token"
    t.datetime "login_token_expires_at"
    t.boolean "onboarding_complete", default: false
    t.string "password_digest", null: false
    t.json "preferences", default: "{}"
    t.json "roles", default: "[]"
    t.string "slack_id"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login_token"], name: "index_users_on_login_token"
  end

  add_foreign_key "applications", "campaigns"
  add_foreign_key "applications", "users"
  add_foreign_key "campaigns", "users"
end
