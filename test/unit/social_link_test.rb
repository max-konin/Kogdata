require 'test_helper'

class SocialLinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'save' do
    user = users(:Mitya)
    link = SocialLink.new :url => 'dsads', :provider => 'vkontakte'
    assert link.valid?, '1. Save new link with url and description'

    link2 = SocialLink.new :url => '9fds0gdsfhdydfguser1', :provider => 'gplus'
    assert link2.valid?, '4. Save new link for g plus'

    link3  = SocialLink.new :url => 'my_new-account', :provider => 'twitter'
    assert link3.valid?, '6. Save twitter link.'

    link3.url = '(asdfasfasdasd)'
    assert !link3.valid?, '7. Save must be fail.'

    link.url = 'nv4rtyr8v3rdsfsdhgfhfghgf'
		link.provider = 'facebook'
    assert !link.valid?, '8. Save must be fail. Too long url'

    link2.provider = 'soundcloud'
    assert !link2.valid?, '9. Fail to save. provider not in list'
  end

  test 'delete' do
    to_del = SocialLink.find('1')
    assert to_del.destroy, 'Remove link with id 1.'
	end
end
