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

ActiveRecord::Schema.define(version: 20170919203306) do

  create_table "big_cards", force: :cascade do |t|
    t.string "state_abbreviation"
    t.string "root_filename"
    t.string "file_group"
    t.text "ocr_text"
    t.boolean "used_check"
    t.string "aspace"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "ocr_check"
  end

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
    t.string "crime"
    t.string "execution_method"
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
    t.string "first_name"
    t.string "last_name"
    t.boolean "date_crime_source_icpsr"
    t.boolean "date_crime_source_index"
    t.boolean "date_crime_source_big"
    t.boolean "date_crime_source_ref"
    t.boolean "date_execution_source_icpsr"
    t.boolean "date_execution_source_index"
    t.boolean "date_execution_source_big"
    t.boolean "date_execution_source_ref"
    t.boolean "age_source_icpsr"
    t.boolean "age_source_index"
    t.boolean "age_source_big"
    t.boolean "age_source_ref"
    t.boolean "race_source_icpsr"
    t.boolean "race_source_index"
    t.boolean "race_source_big"
    t.boolean "race_source_ref"
    t.boolean "sex_source_icpsr"
    t.boolean "sex_source_index"
    t.boolean "sex_source_big"
    t.boolean "sex_source_ref"
    t.boolean "crime_source_icpsr"
    t.boolean "crime_source_index"
    t.boolean "crime_source_big"
    t.boolean "crime_source_ref"
    t.boolean "execution_method_source_icpsr"
    t.boolean "execution_method_source_index"
    t.boolean "execution_method_source_big"
    t.boolean "execution_method_source_ref"
    t.boolean "county_source_icpsr"
    t.boolean "county_source_index"
    t.boolean "county_source_big"
    t.boolean "county_source_ref"
    t.text "big_ocr"
    t.boolean "big_ocr_check"
    t.string "record_type"
    t.text "note"
    t.boolean "name_source_icpsr"
    t.boolean "name_source_index"
    t.boolean "name_source_big"
    t.boolean "name_source_ref"
    t.boolean "jurisdiction_source_icpsr"
    t.boolean "jurisdiction_source_index"
    t.boolean "jurisdiction_source_big"
    t.boolean "jurisdiction_source_ref"
    t.boolean "slave"
    t.boolean "comp_source_icpsr"
    t.boolean "comp_source_index"
    t.boolean "comp_source_big"
    t.boolean "comp_source_ref"
    t.boolean "slave_source_icpsr"
    t.boolean "slave_source_index"
    t.boolean "slave_source_big"
    t.boolean "slave_source_ref"
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
    t.integer "big_id"
    t.string "ref_id"
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

  create_table "references", force: :cascade do |t|
    t.string "filename"
    t.boolean "used_check"
    t.string "aspace"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "folder_name"
    t.boolean "active"
  end

end
