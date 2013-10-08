require 'test_helper'

class ImageControllerTest < ActionController::TestCase
  test "should get bindImage" do
    get :bind
    assert_response :found
  end

end
