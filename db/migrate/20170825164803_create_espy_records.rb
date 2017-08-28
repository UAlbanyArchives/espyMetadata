class CreateEspyRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :espy_records do |t|
      t.string :uuid
      t.boolean :icpsr_record
      t.integer :icpsr_record_id
      t.boolean :index_card
      t.integer :index_card_id
      t.string :index_card_files
      t.boolean :big_card
      t.integer :big_card_id
      t.string :big_card_files
      t.boolean :reference_material
      t.integer :reference_material_id
      t.string :reference_material_files
      t.text :ocr_text
      t.integer :icpsr_id
      t.string :name
      t.date :date_crime
      t.boolean :circa_date_crime
      t.integer :age
      t.string :race
      t.string :sex
      t.string :occupation
      t.string :crime
      t.string :execution_method
      t.string :location_execution
      t.string :jurisdiction
      t.string :state
      t.string :state_abbreviation
      t.integer :county_code
      t.string :county_name
      t.boolean :compensation_case
      t.integer :icpsr_state

      t.timestamps
    end
  end
end
