class ChangeCountyCodeToString < ActiveRecord::Migration[5.1]
  def change
  	change_column :espy_records, :county_code, :string
  end
end
