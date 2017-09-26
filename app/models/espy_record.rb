class EspyRecord < ApplicationRecord

	validates :record_type, :jurisdiction, :county_name, :county_code, presence: true, allow_blank: false
	validate :date_execution, if: :is_dacs_date?
	validate :is_sourced
	validate :icpsr_id, if: :is_icpsr_record?
	validate :county_name, if: :has_county_label?
	validates_inclusion_of :sex, :in => ['Male', 'Female', 'Non-binary', 'Unknown'], :message => "is invalid. Must be one of 'Male', 'Female', 'Non-binary', 'Unknown'.",  allow_blank: true
	validates_inclusion_of :race, :in => ['Black', 'White', 'Native American', 'Hispanic', 'Asian', 'Pacific Islander', 'Asian-Pacific Islander', 'Unknown'], :message => "is invalid. Must be one of 'Black', 'White', 'Native American', 'Hispanic', 'Asian', 'Pacific Islander', 'Asian-Pacific Islander', 'Unknown'.",  allow_blank: true

  
  def has_county_label?
  	unless county_name.blank?
  		if county_name.downcase.include? "county"
  			errors.add(:county_name, " cannot include the word 'county'")
  		end
  	end
  end

  def is_icpsr_record?
  	unless icpsr_id.blank?
	  	if IcpsrRecord.find_by_icpsr_id(icpsr_id.to_i) == nil
	  		errors.add(:icpsr_id, " is not an existing record")
	  	end
	 else
	 	unless date_execution_source_icpsr == false
	 		errors.add(:date_execution_source_icpsr, " cannot be true if now ICPSR record is listed")
	 	end
	 	unless jurisdiction_source_icpsr == false
	 		errors.add(:jurisdiction_source_icpsr, " cannot be true if now ICPSR record is listed")
	 	end
	 	unless county_source_icpsr == false
	 		errors.add(:county_source_icpsr, " cannot be true if now ICPSR record is listed")
	 	end
	 	unless name_source_icpsr == false
	 		errors.add(:name_source_icpsr, " cannot be true if now ICPSR record is listed")
	 	end
	 	unless date_crime_source_icpsr == false
	 		errors.add(:date_crime_source_icpsr, " cannot be true if now ICPSR record is listed")
	 	end
	 	unless age_source_icpsr == false
	 		errors.add(:age_source_icpsr, " cannot be true if now ICPSR record is listed")
	 	end
	 	unless sex_source_icpsr == false
	 		errors.add(:sex_source_icpsr, " cannot be true if now ICPSR record is listed")
	 	end
	 	unless race_source_icpsr == false
	 		errors.add(:race_source_icpsr, " cannot be true if now ICPSR record is listed")
	 	end
	 	unless crime_source_icpsr == false
	 		errors.add(:crime_source_icpsr, " cannot be true if now ICPSR record is listed")
	 	end
	 	unless slave_source_icpsr == false
	 		errors.add(:slave_source_icpsr, " cannot be true if now ICPSR record is listed")
	 	end
	 	unless comp_source_icpsr == false
	 		errors.add(:comp_source_icpsr, " cannot be true if now ICPSR record is listed")
	 	end
	 	unless execution_method_source_icpsr == false
	 		errors.add(:execution_method_source_icpsr, " cannot be true if now ICPSR record is listed")
	 	end
	end
  end

  def is_dacs_date?
  	unless date_execution.length == 4 or date_execution.length == 7 or date_execution.length == 10
  		errors.add(:date_execution, "is invalid date, bad length.")
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

  	unless date_crime.blank?
	  	unless date_crime.length == 4 or date_crime.length == 7 or date_crime.length == 10
	  		errors.add(:date_crime, "is invalid date.")
	  	end
	  	yearCrime = date_crime.split("-")[0].to_i
	  	unless 1600 < yearCrime and yearCrime < 2017
	  		errors.add(:date_crime, "is invalid date.")
	  	end
	end
  end

  def is_sourced
  	unless date_execution_source_icpsr || date_execution_source_index || date_execution_source_big || date_execution_source_ref
      errors.add(:date_execution, "must have at least one source.")
    end
    if jurisdiction == "Unknown"
    else
	    unless jurisdiction_source_icpsr || jurisdiction_source_index || jurisdiction_source_big || jurisdiction_source_ref
	      errors.add(:jurisdiction, "must have at least one source.")
	    end
	end
    unless county_source_icpsr || county_source_index || county_source_big || county_source_ref
      errors.add(:county_name, "must have at least one source.")
    end

  	unless first_name.blank? and last_name.blank?
	  	unless name_source_icpsr || name_source_index || name_source_big || name_source_ref
	      errors.add(:first_name, "must have at least one source.")
	    end
	end
	unless date_crime.blank?
	    unless date_crime_source_icpsr || date_crime_source_index || date_crime_source_big || date_crime_source_ref
	      errors.add(:date_crime, "must have at least one source.")
	    end
	end
	unless age.blank?
	    unless age_source_icpsr || age_source_index || age_source_big || age_source_ref
	      errors.add(:age, "must have at least one source.")
	    end
	end
	unless sex.blank?
	    unless sex_source_icpsr || sex_source_index || sex_source_big || sex_source_ref
	      errors.add(:sex, "must have at least one source.")
	    end
	end
	unless race.blank?
	    unless race_source_icpsr || race_source_index || race_source_big || race_source_ref
	      errors.add(:race, "must have at least one source.")
	    end
	end
	unless crime.blank? || crime == "Unknown"
	    unless crime_source_icpsr || crime_source_index || crime_source_big || crime_source_ref
	      errors.add(:crime, "must have at least one source.")
	    end
	end
	if slave == true
	    unless slave_source_icpsr || slave_source_index || slave_source_big || slave_source_ref
	      errors.add(:slave, "must have at least one source.")
	    end
	end
	if compensation_case == true
		unless comp_source_icpsr || comp_source_index || comp_source_big || comp_source_ref
	      errors.add(:compensation_case, "must have at least one source.")
	    end
	    unless slave == true
	    	errors.add(:compensation_case, "cannot be true unless slave is true.")
	    end
	end
	unless execution_method.blank?
	    unless execution_method_source_icpsr || execution_method_source_index || execution_method_source_big || execution_method_source_ref
	      errors.add(:execution_method, "must have at least one source.")
	    end
	end

  end
end

