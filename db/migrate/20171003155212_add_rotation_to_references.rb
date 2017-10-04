class AddRotationToReferences < ActiveRecord::Migration[5.1]
  def change
    add_column :references, :rotation, :integer
  end
end
