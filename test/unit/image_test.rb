require 'test_helper'

class ImageTest < ActiveSupport::TestCase
	test "name is uniq" do
		i = Image.new(:name => "i", :src => "http://google.com/favicon.ico")
		t = Image.new(:name => "i", :src => "http://google.com/favicon.ico")
		assert i.name != t.name
	end
end
