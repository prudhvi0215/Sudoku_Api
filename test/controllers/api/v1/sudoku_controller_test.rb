require "test_helper"

class Api::V1::SudokuControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_sudoku_create_url
    assert_response :success
  end
end
