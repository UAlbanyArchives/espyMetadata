class IcpsrRecord < ApplicationRecord
	has_and_belongs_to_many :references
	
	validates :date_execution, :state_abbreviation, presence: true

end
