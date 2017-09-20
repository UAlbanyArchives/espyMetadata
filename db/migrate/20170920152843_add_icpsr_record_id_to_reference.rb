class AddIcpsrRecordIdToReference < ActiveRecord::Migration[5.1]
  def change
    add_column :references, :icpsr_record_id, :integer
  end
end
