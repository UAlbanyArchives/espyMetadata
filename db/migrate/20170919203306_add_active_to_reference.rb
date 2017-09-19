class AddActiveToReference < ActiveRecord::Migration[5.1]
  def change
    add_column :references, :active, :boolean
  end
end
