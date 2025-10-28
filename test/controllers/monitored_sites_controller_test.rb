require "test_helper"

class MonitoredSitesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get monitored_sites_index_url
    assert_response :success
  end

  test "should get show" do
    get monitored_sites_show_url
    assert_response :success
  end

  test "should get new" do
    get monitored_sites_new_url
    assert_response :success
  end

  test "should get create" do
    get monitored_sites_create_url
    assert_response :success
  end

  test "should get edit" do
    get monitored_sites_edit_url
    assert_response :success
  end

  test "should get update" do
    get monitored_sites_update_url
    assert_response :success
  end

  test "should get destroy" do
    get monitored_sites_destroy_url
    assert_response :success
  end
end
