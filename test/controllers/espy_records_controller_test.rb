require 'test_helper'

class EspyRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @espy_record = espy_records(:one)
  end

  test "should get index" do
    get espy_records_url
    assert_response :success
  end

  test "should get new" do
    get new_espy_record_url
    assert_response :success
  end

  test "should create espy_record" do
    assert_difference('EspyRecord.count') do
      post espy_records_url, params: { espy_record: { age: @espy_record.age, big_card: @espy_record.big_card, big_card_files: @espy_record.big_card_files, big_card_id: @espy_record.big_card_id, circa_date_crime: @espy_record.circa_date_crime, compensation_case: @espy_record.compensation_case, county_code: @espy_record.county_code, county_name: @espy_record.county_name, crime: @espy_record.crime, date_crime: @espy_record.date_crime, execution_method: @espy_record.execution_method, icpsr_id: @espy_record.icpsr_id, icpsr_record: @espy_record.icpsr_record, icpsr_record_id: @espy_record.icpsr_record_id, icpsr_state: @espy_record.icpsr_state, index_card: @espy_record.index_card, index_card_files: @espy_record.index_card_files, index_card_id: @espy_record.index_card_id, jurisdiction: @espy_record.jurisdiction, location_execution: @espy_record.location_execution, name: @espy_record.name, occupation: @espy_record.occupation, ocr_text: @espy_record.ocr_text, race: @espy_record.race, reference_material: @espy_record.reference_material, reference_material_files: @espy_record.reference_material_files, reference_material_id: @espy_record.reference_material_id, sex: @espy_record.sex, state: @espy_record.state, state_abbreviation: @espy_record.state_abbreviation, uuid: @espy_record.uuid } }
    end

    assert_redirected_to espy_record_url(EspyRecord.last)
  end

  test "should show espy_record" do
    get espy_record_url(@espy_record)
    assert_response :success
  end

  test "should get edit" do
    get edit_espy_record_url(@espy_record)
    assert_response :success
  end

  test "should update espy_record" do
    patch espy_record_url(@espy_record), params: { espy_record: { age: @espy_record.age, big_card: @espy_record.big_card, big_card_files: @espy_record.big_card_files, big_card_id: @espy_record.big_card_id, circa_date_crime: @espy_record.circa_date_crime, compensation_case: @espy_record.compensation_case, county_code: @espy_record.county_code, county_name: @espy_record.county_name, crime: @espy_record.crime, date_crime: @espy_record.date_crime, execution_method: @espy_record.execution_method, icpsr_id: @espy_record.icpsr_id, icpsr_record: @espy_record.icpsr_record, icpsr_record_id: @espy_record.icpsr_record_id, icpsr_state: @espy_record.icpsr_state, index_card: @espy_record.index_card, index_card_files: @espy_record.index_card_files, index_card_id: @espy_record.index_card_id, jurisdiction: @espy_record.jurisdiction, location_execution: @espy_record.location_execution, name: @espy_record.name, occupation: @espy_record.occupation, ocr_text: @espy_record.ocr_text, race: @espy_record.race, reference_material: @espy_record.reference_material, reference_material_files: @espy_record.reference_material_files, reference_material_id: @espy_record.reference_material_id, sex: @espy_record.sex, state: @espy_record.state, state_abbreviation: @espy_record.state_abbreviation, uuid: @espy_record.uuid } }
    assert_redirected_to espy_record_url(@espy_record)
  end

  test "should destroy espy_record" do
    assert_difference('EspyRecord.count', -1) do
      delete espy_record_url(@espy_record)
    end

    assert_redirected_to espy_records_url
  end
end
