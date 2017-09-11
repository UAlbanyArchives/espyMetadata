class AddTypeToEspyRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :espy_records, :type, :string
  end
end
