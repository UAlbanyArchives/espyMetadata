class ChangeDatesToDatetime < ActiveRecord::Migration[5.1]
  def change
  	change_column :espy_records, :date_execution, :datetime
  	change_column :espy_records, :date_crime, :datetime
  end
end
