class AddNameSourcesToEspyRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :espy_records, :name_source_icpsr, :boolean
    add_column :espy_records, :name_source_index, :boolean
    add_column :espy_records, :name_source_big, :boolean
    add_column :espy_records, :name_source_ref, :boolean
  end
end
