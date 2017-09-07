class AddAspaceToIndexCards < ActiveRecord::Migration[5.1]
  def change
    add_column :index_cards, :aspace, :string
  end
end
