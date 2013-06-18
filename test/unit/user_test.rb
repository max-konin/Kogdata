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

  test "save" do
    user = User.new :name => "SuperUser", :password=> "superpass", :role => :admin, :email => "super@user.com"
    assert user.save!
  end

  test "admin ability" do
    user = User.new :role => :admin
    ability = Ability.new user
    assert ability.can?(:read, User)
    assert ability.can?(:destroy, User)

    user = users(:Max)
    ability = Ability.new user
    assert ability.can?(:destroy, User)

  end

end
