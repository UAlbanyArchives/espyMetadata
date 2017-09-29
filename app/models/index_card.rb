class IndexCard < ApplicationRecord

	validates :state_abbreviation, :root_filename, :file_group, presence: true
	validates :state_abbreviation, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
	validates :root_filename, :file_group, uniqueness: true
	validates :root_filename, :file_group, check_files: true
		
end
