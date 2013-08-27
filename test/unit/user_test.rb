require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "default role" do
    user = User.new
    assert user.role? :client
  end

  test "role?" do
    user = User.new
    user.role = :client
    assert user.role? :client
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

  test 'client ability' do
    user = users(:Mitya)
    ability = Ability.new user
    assert ability.can?(:read, User)
    assert ability.can?(:read, user)
  end

  test 'price validation' do
    user = User.new :role => :contractor, :name => 'vasya1', :password => 'pupkin', :email => 'vasya1@pupkin.com'
    assert !(user.save), 'contractor without price'
    user = User.new :role => :client, :name => 'vasya2', :password => 'pupkin', :email => 'vasya2@pupkin.com'
    assert (user.save), 'client'
    user = User.new :role => :contractor, :name => 'vasya3', :password => 'pupkin', :email => 'vasya3@pupkin.com', :price => 200
    assert (user.save), 'contractor with prise'
    user = User.new :role => :contractor, :name => 'vasya4', :password => 'pupkin', :email => 'vasya4@pupkin.com', :price => 'priceless'
    assert !(user.save), 'contractor with string price'
    user = User.new :role => :client, :name => 'vasya4', :password => 'pupkin', :email => 'vasya4@pupkin.com', :price => 200
    assert (user.save), 'client with price'
    assert_nil user.price, 'prise of client should not be saved'
  end

end
