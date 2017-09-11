class RemoveOldFieldsFromEspyRecords < ActiveRecord::Migration[5.1]
  def change
    remove_column :espy_records, :occupation, :string
    remove_column :espy_records, :location_execution, :string
  end
end
