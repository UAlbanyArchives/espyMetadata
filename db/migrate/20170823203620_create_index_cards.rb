class CreateIndexCards < ActiveRecord::Migration[5.1]
  def change
    create_table :index_cards do |t|
      t.string :state_abbreviation
      t.string :root_filename
      t.string :file_group
      t.text :ocr_text
      t.boolean :used_check

      t.timestamps
    end
  end
end
