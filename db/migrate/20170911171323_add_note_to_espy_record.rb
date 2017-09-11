class AddNoteToEspyRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :espy_records, :note, :text
  end
end
