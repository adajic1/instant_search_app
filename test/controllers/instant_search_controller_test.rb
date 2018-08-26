require 'test_helper'

class InstantSearchControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get instant_search_index_url
    assert_response :success
  end

end
