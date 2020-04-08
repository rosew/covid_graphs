require 'test_helper'

class GraphsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get graph_show_url
    assert_response :success
  end

end
