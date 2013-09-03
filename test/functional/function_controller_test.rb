require 'test_helper'

class FunctionControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
