class CreateIcpsrReferencesJoinTable < ActiveRecord::Migration[5.1]
  def change
  	create_join_table :icpsr_records, :references
  end
end
