class AddFullnamesToEspyRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :espy_records, :first_name, :string
    add_column :espy_records, :last_name, :string
  end
end
