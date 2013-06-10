require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "role?" do
    user = User.new
    user.role = :client
    assert (user.role? :client)
    assert !(user.role? :admin)
    user.role = 'client'
    assert (user.role? :client)
  end

end
