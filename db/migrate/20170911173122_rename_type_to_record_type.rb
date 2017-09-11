class RenameTypeToRecordType < ActiveRecord::Migration[5.1]
  def change
  	rename_column :espy_records, :type, :record_type
  end
end
