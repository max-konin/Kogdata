require 'test_helper'

class ImageControllerTest < ActionController::TestCase
  test "should get bindImage" do
    get :bindImage
    assert_response :success
  end

end
