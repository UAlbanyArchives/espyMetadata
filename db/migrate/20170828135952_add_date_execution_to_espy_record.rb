class AddDateExecutionToEspyRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :espy_records, :date_execution, :date
    add_column :espy_records, :circa_date_execution, :boolean
  end
end
