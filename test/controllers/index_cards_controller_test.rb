require 'test_helper'

class IndexCardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @index_card = index_cards(:one)
  end

  test "should get index" do
    get index_cards_url
    assert_response :success
  end

  test "should get new" do
    get new_index_card_url
    assert_response :success
  end

  test "should create index_card" do
    assert_difference('IndexCard.count') do
      post index_cards_url, params: { index_card: { file_group: @index_card.file_group, ocr_text: @index_card.ocr_text, root_filename: @index_card.root_filename, state_abbreviation: @index_card.state_abbreviation, used_check: @index_card.used_check } }
    end

    assert_redirected_to index_card_url(IndexCard.last)
  end

  test "should show index_card" do
    get index_card_url(@index_card)
    assert_response :success
  end

  test "should get edit" do
    get edit_index_card_url(@index_card)
    assert_response :success
  end

  test "should update index_card" do
    patch index_card_url(@index_card), params: { index_card: { file_group: @index_card.file_group, ocr_text: @index_card.ocr_text, root_filename: @index_card.root_filename, state_abbreviation: @index_card.state_abbreviation, used_check: @index_card.used_check } }
    assert_redirected_to index_card_url(@index_card)
  end

  test "should destroy index_card" do
    assert_difference('IndexCard.count', -1) do
      delete index_card_url(@index_card)
    end

    assert_redirected_to index_cards_url
  end
end
