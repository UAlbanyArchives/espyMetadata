class ChangeEspyRefIdToString < ActiveRecord::Migration[5.1]
  def change
  	change_table :espy_records do |t|
	  t.change :reference_material_id, :string
	end
  end
end
