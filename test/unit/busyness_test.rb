require 'test_helper'
require 'date'

class BusynessTest < ActiveSupport::TestCase
	test "there must be a start" do
		Busyness.new(:desc => "There will be an error.", :end => Date.today)
		assert false
	end

	test "there must be end" do
		Busyness.new(:desc => "There will be an error.", :start => Date.today)
		assert false
	end
end
