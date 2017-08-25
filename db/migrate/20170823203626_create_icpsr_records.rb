class CreateIcpsrRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :icpsr_records do |t|
      t.boolean :used_check
      t.integer :icpsr_id
      t.string :name
      t.string :date_execution
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
