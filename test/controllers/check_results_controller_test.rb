require "test_helper"

class CheckResultsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get check_results_index_url
    assert_response :success
  end

  test "should get show" do
    get check_results_show_url
    assert_response :success
  end
end
