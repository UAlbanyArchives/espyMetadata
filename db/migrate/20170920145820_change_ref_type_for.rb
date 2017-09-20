class ChangeRefTypeFor < ActiveRecord::Migration[5.1]
  def change
  	change_table :icpsr_records do |t|
	  t.change :ref_id, :integer
	end
  end
end
