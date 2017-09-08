require 'test_helper'

class BigCardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @big_card = big_cards(:one)
  end

  test "should get index" do
    get big_cards_url
    assert_response :success
  end

  test "should get new" do
    get new_big_card_url
    assert_response :success
  end

  test "should create big_card" do
    assert_difference('BigCard.count') do
      post big_cards_url, params: { big_card: { aspace: @big_card.aspace, file_group: @big_card.file_group, ocr_text: @big_card.ocr_text, root_filename: @big_card.root_filename, state_abbreviation: @big_card.state_abbreviation, used_check: @big_card.used_check } }
    end

    assert_redirected_to big_card_url(BigCard.last)
  end

  test "should show big_card" do
    get big_card_url(@big_card)
    assert_response :success
  end

  test "should get edit" do
    get edit_big_card_url(@big_card)
    assert_response :success
  end

  test "should update big_card" do
    patch big_card_url(@big_card), params: { big_card: { aspace: @big_card.aspace, file_group: @big_card.file_group, ocr_text: @big_card.ocr_text, root_filename: @big_card.root_filename, state_abbreviation: @big_card.state_abbreviation, used_check: @big_card.used_check } }
    assert_redirected_to big_card_url(@big_card)
  end

  test "should destroy big_card" do
    assert_difference('BigCard.count', -1) do
      delete big_card_url(@big_card)
    end

    assert_redirected_to big_cards_url
  end
end
