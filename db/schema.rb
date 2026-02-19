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

ActiveRecord::Schema[8.1].define(version: 2026_02_19_000320) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "campaign_memberships", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["campaign_id", "user_id"], name: "index_campaign_memberships_on_campaign_id_and_user_id", unique: true
    t.index ["campaign_id"], name: "index_campaign_memberships_on_campaign_id"
    t.index ["user_id"], name: "index_campaign_memberships_on_user_id"
  end

  create_table "campaign_messages", force: :cascade do |t|
    t.text "body", null: false
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["campaign_id"], name: "index_campaign_messages_on_campaign_id"
    t.index ["user_id"], name: "index_campaign_messages_on_user_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "atmosphere"
    t.datetime "created_at", null: false
    t.bigint "dm_id"
    t.string "needs", default: [], array: true
    t.integer "players_count", default: 0, null: false
    t.string "start_time"
    t.string "status", default: "Forming", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["dm_id"], name: "index_campaigns_on_dm_id"
  end

  create_table "solid_cable_messages", force: :cascade do |t|
    t.binary "channel", null: false
    t.bigint "channel_hash", null: false
    t.datetime "created_at", null: false
    t.binary "payload", null: false
    t.index ["channel"], name: "index_solid_cable_messages_on_channel"
    t.index ["channel_hash"], name: "index_solid_cable_messages_on_channel_hash"
    t.index ["created_at"], name: "index_solid_cable_messages_on_created_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "atmospheres", default: [], array: true
    t.jsonb "availability", default: {}
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.boolean "dm_experience", default: false, null: false
    t.string "email"
    t.boolean "email_notifications", default: true, null: false
    t.string "experience_level"
    t.string "hackclub_id", null: false
    t.string "name"
    t.datetime "queued_at"
    t.boolean "queued_for_matching", default: false, null: false
    t.string "roles", default: [], array: true
    t.string "styles", default: [], array: true
    t.datetime "updated_at", null: false
    t.index ["hackclub_id"], name: "index_users_on_hackclub_id", unique: true
  end

  add_foreign_key "campaign_memberships", "campaigns"
  add_foreign_key "campaign_memberships", "users"
  add_foreign_key "campaign_messages", "campaigns"
  add_foreign_key "campaign_messages", "users"
  add_foreign_key "campaigns", "users", column: "dm_id"
end
