class FixDroppedTable < ActiveRecord::Migration[5.1]
  def change
  	create_table :big_cards do |t|
      t.string :state_abbreviation
      t.string :root_filename
      t.string :file_group
      t.text :ocr_text
      t.boolean :used_check
      t.string :aspace

      t.timestamps
    end
  end
end
