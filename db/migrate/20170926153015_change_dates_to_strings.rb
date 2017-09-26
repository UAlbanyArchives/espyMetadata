class ChangeDatesToStrings < ActiveRecord::Migration[5.1]
  def change
  	change_column :espy_records, :date_execution, :string
  	change_column :espy_records, :date_crime, :string
  end
end
