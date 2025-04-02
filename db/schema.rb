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

ActiveRecord::Schema[8.0].define(version: 2025_04_02_194122) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "incidents", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.string "severity"
    t.string "status", default: "active"
    t.string "creator_name"
    t.string "creator_id"
    t.string "slack_channel_id"
    t.datetime "resolved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "team_id"
    t.index ["status"], name: "index_incidents_on_status"
  end

  create_table "teams", force: :cascade do |t|
    t.string "team_id"
    t.string "team_name"
    t.string "access_token"
    t.string "bot_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
