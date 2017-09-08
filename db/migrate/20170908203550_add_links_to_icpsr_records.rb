class AddLinksToIcpsrRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :icpsr_records, :big_id, :integer
    add_column :icpsr_records, :ref_id, :integer
  end
end
