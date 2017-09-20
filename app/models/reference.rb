class Reference < ApplicationRecord
	has_and_belongs_to_many :icpsr_records
end
