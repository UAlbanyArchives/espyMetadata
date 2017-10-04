class IcpsrRecord < ApplicationRecord
	has_and_belongs_to_many :references
	
	validates :date_execution, :state_abbreviation, presence: true
	validate :date_execution, if: :is_dacs_date?
	validate :county_name, if: :has_county_label?

def has_county_label?
  	unless county_name.blank?
  		if county_name.downcase.include? "county"
  			errors.add(:county_name, " cannot include the word 'county'")
  		end
  	end
  end

def is_dacs_date?
  	unless date_execution.length == 4 or date_execution.length == 7 or date_execution.length == 10
  		errors.add(:date_execution, "is invalid date, bad length.")
  	end
  	if date_execution.include? "/"
  		errors.add(:date_execution, "is invalid date, cannot contain '/'.")
  	end
  	if date_execution.include? "\\"
  		errors.add(:date_execution, "is invalid date, cannot contain '\\'.")
  	end
  	year = date_execution.split("-")[0].to_i
  	unless 1600 < year and year < 2017
  		errors.add(:date_execution, "is invalid date, outside of year range.")
  	end
  	if date_execution.count('-') == 0
  	elsif date_execution.count('-') == 1
  		unless ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"].include?(date_execution.split("-")[1])
  			errors.add(:date_execution, "is invalid date, month is invalid.")
  		end
  	elsif date_execution.count('-') == 2
  		unless ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"].include?(date_execution.split("-")[1])
  			errors.add(:date_execution, "is invalid date, month is invalid.")
  		end
  		day = date_execution.split("-")[2]
  		if day.to_i > 31
  			errors.add(:date_execution, "is invalid date, day is over 31.")
  		elsif day.to_i < 10
  			unless ["01", "02", "03", "04", "05", "06", "07", "08", "09"].include?(day)
  				errors.add(:date_execution, "is invalid date, day is invalid single digit.")
  			end
  		end
  	else
  		errors.add(:date_execution, "is invalid date.")
  	end
  end

end
