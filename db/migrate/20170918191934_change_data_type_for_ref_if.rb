class ChangeDataTypeForRefIf < ActiveRecord::Migration[5.1]
  def change
  	change_table :icpsr_records do |t|
      t.change :ref_id, :string
    end
  end
end
