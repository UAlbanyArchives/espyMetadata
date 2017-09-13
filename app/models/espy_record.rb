class EspyRecord < ApplicationRecord
	def a_method_used_for_validation_purposes
    	errors.add(:date_execution, "cannot contain the characters !@#%*()_-+=")
  	end

	validates :date_execution, :jurisdiction, :county_name, :county_code, presence: true

end
