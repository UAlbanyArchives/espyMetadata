require 'test_helper'

class IcpsrRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @icpsr_record = icpsr_records(:one)
  end

  test "should get index" do
    get icpsr_records_url
    assert_response :success
  end

  test "should get new" do
    get new_icpsr_record_url
    assert_response :success
  end

  test "should create icpsr_record" do
    assert_difference('IcpsrRecord.count') do
      post icpsr_records_url, params: { icpsr_record: { age: @icpsr_record.age, compensation_case: @icpsr_record.compensation_case, county_code: @icpsr_record.county_code, county_name: @icpsr_record.county_name, crime: @icpsr_record.crime, date_execution: @icpsr_record.date_execution, execution_method: @icpsr_record.execution_method, icpsr_id: @icpsr_record.icpsr_id, icpsr_state: @icpsr_record.icpsr_state, jurisdiction: @icpsr_record.jurisdiction, location_execution: @icpsr_record.location_execution, name: @icpsr_record.name, occupation: @icpsr_record.occupation, race: @icpsr_record.race, sex: @icpsr_record.sex, state: @icpsr_record.state, state_abbreviation: @icpsr_record.state_abbreviation, used_check: @icpsr_record.used_check } }
    end

    assert_redirected_to icpsr_record_url(IcpsrRecord.last)
  end

  test "should show icpsr_record" do
    get icpsr_record_url(@icpsr_record)
    assert_response :success
  end

  test "should get edit" do
    get edit_icpsr_record_url(@icpsr_record)
    assert_response :success
  end

  test "should update icpsr_record" do
    patch icpsr_record_url(@icpsr_record), params: { icpsr_record: { age: @icpsr_record.age, compensation_case: @icpsr_record.compensation_case, county_code: @icpsr_record.county_code, county_name: @icpsr_record.county_name, crime: @icpsr_record.crime, date_execution: @icpsr_record.date_execution, execution_method: @icpsr_record.execution_method, icpsr_id: @icpsr_record.icpsr_id, icpsr_state: @icpsr_record.icpsr_state, jurisdiction: @icpsr_record.jurisdiction, location_execution: @icpsr_record.location_execution, name: @icpsr_record.name, occupation: @icpsr_record.occupation, race: @icpsr_record.race, sex: @icpsr_record.sex, state: @icpsr_record.state, state_abbreviation: @icpsr_record.state_abbreviation, used_check: @icpsr_record.used_check } }
    assert_redirected_to icpsr_record_url(@icpsr_record)
  end

  test "should destroy icpsr_record" do
    assert_difference('IcpsrRecord.count', -1) do
      delete icpsr_record_url(@icpsr_record)
    end

    assert_redirected_to icpsr_records_url
  end
end
