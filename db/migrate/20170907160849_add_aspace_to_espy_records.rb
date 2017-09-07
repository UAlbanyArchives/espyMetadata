class AddAspaceToEspyRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :espy_records, :index_card_aspace, :string
    add_column :espy_records, :big_card_aspace, :string
    add_column :espy_records, :reference_material_aspace, :string
    add_column :espy_records, :ocr_fixed, :boolean
  end
end
