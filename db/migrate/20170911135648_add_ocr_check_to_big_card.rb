class AddOcrCheckToBigCard < ActiveRecord::Migration[5.1]
  def change
    add_column :big_cards, :ocr_check, :boolean
  end
end
