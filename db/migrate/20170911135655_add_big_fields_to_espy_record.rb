class AddBigFieldsToEspyRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :espy_records, :big_ocr, :text
    add_column :espy_records, :big_ocr_check, :boolean
  end
end
