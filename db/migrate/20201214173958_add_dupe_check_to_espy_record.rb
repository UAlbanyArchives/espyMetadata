class AddDupeCheckToEspyRecord < ActiveRecord::Migration[5.2]
  def change
    add_column :espy_records, :dupe_check, :boolean
  end
end
