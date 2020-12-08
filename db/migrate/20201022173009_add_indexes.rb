class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :espy_records, :state_abbreviation
    add_index :big_cards, :state_abbreviation
    add_index :icpsr_records, :state_abbreviation
    add_index :index_cards, :state_abbreviation
  end
end
