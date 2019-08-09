class AddDeletedToIcpsrRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :icpsr_records, :deleted, :boolean
  end
end
