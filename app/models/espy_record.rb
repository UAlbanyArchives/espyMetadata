class EspyRecord < ApplicationRecord

	validates :record_type, :date_execution, :jurisdiction, :county_name, :county_code, presence: true
	
	if not @age.blank?
		validates :age, numericality: { only_integer: true }
	end

	validate :is_sourced

  def is_sourced
  	if not @first_name.blank? || @first_name.blank?
	  	unless @name_source_icpsr || @name_source_index || @name_source_big || @name_source_ref
	      errors.add(:first_name, "must have at least one source.")
	    end
	end
	if not @date_execution.blank?
	    unless @date_execution_source_icpsr || @date_execution_source_index || @date_execution_source_big || @date_execution_source_ref
	      errors.add(:date_execution, "must have at least one source.")
	    end
	end
	if not @date_crime.blank?
	    unless @date_crime_source_icpsr || @date_crime_source_index || @date_crime_source_big || @date_crime_source_ref
	      errors.add(:date_crime, "must have at least one source.")
	    end
	end

  end
end

