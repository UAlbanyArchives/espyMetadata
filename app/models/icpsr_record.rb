class IcpsrRecord < ApplicationRecord

	validates :name, :state_abbreviation, presence: true

end
