class AddSlavesSourcesToEspyRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :espy_records, :slave, :boolean
    add_column :espy_records, :comp_source_icpsr, :boolean
    add_column :espy_records, :comp_source_index, :boolean
    add_column :espy_records, :comp_source_big, :boolean
    add_column :espy_records, :comp_source_ref, :boolean
    add_column :espy_records, :slave_source_icpsr, :boolean
    add_column :espy_records, :slave_source_index, :boolean
    add_column :espy_records, :slave_source_big, :boolean
    add_column :espy_records, :slave_source_ref, :boolean
  end
end
