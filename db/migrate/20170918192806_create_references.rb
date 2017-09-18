class CreateReferences < ActiveRecord::Migration[5.1]
  def change
    create_table :references do |t|
      t.string :filename
      t.boolean :used_check
      t.string :aspace

      t.timestamps
    end
  end
end
