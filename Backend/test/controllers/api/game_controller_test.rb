require 'test_helper'

class Api::GameControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_game_index_url
    assert_response :success
  end

  test "should get post:create" do
    get api_game_post:create_url
    assert_response :success
  end

end
