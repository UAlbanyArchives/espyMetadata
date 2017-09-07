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

ActiveRecord::Schema.define(version: 20170907163813) do

  create_table "espy_records", force: :cascade do |t|
    t.string "uuid"
    t.boolean "icpsr_record"
    t.integer "icpsr_record_id"
    t.boolean "index_card"
    t.integer "index_card_id"
    t.string "index_card_files"
    t.boolean "big_card"
    t.integer "big_card_id"
    t.string "big_card_files"
    t.boolean "reference_material"
    t.integer "reference_material_id"
    t.string "reference_material_files"
    t.text "ocr_text"
    t.integer "icpsr_id"
    t.string "name"
    t.date "date_crime"
    t.boolean "circa_date_crime"
    t.integer "age"
    t.string "race"
    t.string "sex"
    t.string "occupation"
    t.string "crime"
    t.string "execution_method"
    t.string "location_execution"
    t.string "jurisdiction"
    t.string "state"
    t.string "state_abbreviation"
    t.integer "county_code"
    t.string "county_name"
    t.boolean "compensation_case"
    t.integer "icpsr_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_execution"
    t.boolean "circa_date_execution"
    t.string "index_card_aspace"
    t.string "big_card_aspace"
    t.string "reference_material_aspace"
    t.boolean "ocr_fixed"
  end

  create_table "icpsr_records", force: :cascade do |t|
    t.boolean "used_check"
    t.integer "icpsr_id"
    t.string "name"
    t.string "date_execution"
    t.integer "age"
    t.string "race"
    t.string "sex"
    t.string "occupation"
    t.string "crime"
    t.string "execution_method"
    t.string "location_execution"
    t.string "jurisdiction"
    t.string "state"
    t.string "state_abbreviation"
    t.integer "county_code"
    t.string "county_name"
    t.boolean "compensation_case"
    t.integer "icpsr_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "index_cards", force: :cascade do |t|
    t.string "state_abbreviation"
    t.string "root_filename"
    t.string "file_group"
    t.text "ocr_text"
    t.boolean "used_check"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "aspace"
  end

end
