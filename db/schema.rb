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

ActiveRecord::Schema[8.1].define(version: 2026_08_19_042923) do
  create_table "accomplishment_skills", force: :cascade do |t|
    t.integer "accomplishment_id", null: false
    t.datetime "created_at", null: false
    t.integer "skill_id", null: false
    t.datetime "updated_at", null: false
    t.index ["accomplishment_id"], name: "index_accomplishment_skills_on_accomplishment_id"
    t.index ["skill_id"], name: "index_accomplishment_skills_on_skill_id"
  end

  create_table "accomplishments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "hide_from_highlights", default: false, null: false
    t.integer "highlight_order"
    t.string "metric"
    t.integer "position"
    t.integer "role_id", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_accomplishments_on_role_id"
  end

  create_table "carline_days", force: :cascade do |t|
    t.integer "avg_wait_minutes"
    t.integer "cars_in_line"
    t.datetime "created_at", null: false
    t.string "dismissal_time"
    t.text "note"
    t.date "observed_on"
    t.datetime "updated_at", null: false
    t.integer "worst_wait_minutes"
  end

  create_table "complaints", force: :cascade do |t|
    t.string "category"
    t.string "channel"
    t.datetime "created_at", null: false
    t.integer "family_id"
    t.string "family_label"
    t.date "logged_on"
    t.integer "severity"
    t.datetime "updated_at", null: false
    t.index ["family_id"], name: "index_complaints_on_family_id"
  end

  create_table "educations", force: :cascade do |t|
    t.date "completed_on"
    t.datetime "created_at", null: false
    t.string "credential"
    t.string "honor"
    t.string "institution"
    t.string "location"
    t.integer "position"
    t.string "tag"
    t.datetime "updated_at", null: false
  end

  create_table "families", force: :cascade do |t|
    t.boolean "carpool_interested"
    t.datetime "created_at", null: false
    t.boolean "extended_day"
    t.string "label"
    t.datetime "updated_at", null: false
    t.boolean "wants_bus"
  end

  create_table "profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "github_url"
    t.string "headline"
    t.text "intro"
    t.string "linkedin_url"
    t.string "location"
    t.string "name"
    t.text "print_summary"
    t.text "tagline"
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "current"
    t.date "ends_on"
    t.string "kind"
    t.string "location"
    t.string "organization"
    t.integer "position"
    t.text "print_bullets"
    t.boolean "print_condensed", default: false, null: false
    t.date "starts_on"
    t.text "summary"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "accomplishment_skills", "accomplishments"
  add_foreign_key "accomplishment_skills", "skills"
  add_foreign_key "accomplishments", "roles"
  add_foreign_key "complaints", "families"
end
