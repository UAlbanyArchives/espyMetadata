class AddFolderNameToReference < ActiveRecord::Migration[5.1]
  def change
    add_column :references, :folder_name, :string
  end
end
