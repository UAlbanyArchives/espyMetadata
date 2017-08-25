json.extract! icpsr_record, :id, :used_check, :icpsr_id, :name, :date_execution, :age, :race, :sex, :occupation, :crime, :execution_method, :location_execution, :jurisdiction, :state, :state_abbreviation, :county_code, :county_name, :compensation_case, :icpsr_state, :created_at, :updated_at
json.url icpsr_record_url(icpsr_record, format: :json)
