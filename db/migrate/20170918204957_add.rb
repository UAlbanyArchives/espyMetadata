class Add < ActiveRecord::Migration[5.1]
  def change
  	add_column :reference, :folder_name, :string
  end
end
