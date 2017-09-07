class AddSourcesToEspyRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :espy_records, :date_crime_source_icpsr, :boolean
    add_column :espy_records, :date_crime_source_index, :boolean
    add_column :espy_records, :date_crime_source_big, :boolean
    add_column :espy_records, :date_crime_source_ref, :boolean
    add_column :espy_records, :date_execution_source_icpsr, :boolean
    add_column :espy_records, :date_execution_source_index, :boolean
    add_column :espy_records, :date_execution_source_big, :boolean
    add_column :espy_records, :date_execution_source_ref, :boolean
    add_column :espy_records, :age_source_icpsr, :boolean
    add_column :espy_records, :age_source_index, :boolean
    add_column :espy_records, :age_source_big, :boolean
    add_column :espy_records, :age_source_ref, :boolean
    add_column :espy_records, :race_source_icpsr, :boolean
    add_column :espy_records, :race_source_index, :boolean
    add_column :espy_records, :race_source_big, :boolean
    add_column :espy_records, :race_source_ref, :boolean
    add_column :espy_records, :sex_source_icpsr, :boolean
    add_column :espy_records, :sex_source_index, :boolean
    add_column :espy_records, :sex_source_big, :boolean
    add_column :espy_records, :sex_source_ref, :boolean
    add_column :espy_records, :crime_source_icpsr, :boolean
    add_column :espy_records, :crime_source_index, :boolean
    add_column :espy_records, :crime_source_big, :boolean
    add_column :espy_records, :crime_source_ref, :boolean
    add_column :espy_records, :execution_method_source_icpsr, :boolean
    add_column :espy_records, :execution_method_source_index, :boolean
    add_column :espy_records, :execution_method_source_big, :boolean
    add_column :espy_records, :execution_method_source_ref, :boolean
    add_column :espy_records, :county_source_icpsr, :boolean
    add_column :espy_records, :county_source_index, :boolean
    add_column :espy_records, :county_source_big, :boolean
    add_column :espy_records, :county_source_ref, :boolean
  end
end
