class AddOwnerNameField < ActiveRecord::Migration[5.1]
  def change
    add_column :espy_records, :owner_name, :string
  end
end
