require "test_helper"

class InitPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get first" do
    get init_pages_first_url
    assert_response :success
  end

  test "should get policy" do
    get init_pages_policy_url
    assert_response :success
  end
end
