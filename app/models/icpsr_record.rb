class IcpsrRecord < ApplicationRecord

	validates :date_execution, :state_abbreviation, presence: true

end
