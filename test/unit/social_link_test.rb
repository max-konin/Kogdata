require 'test_helper'

class SocialLinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'save' do
    link = SocialLink.new :url => 'http://vk.com/user1', :description => 'Link to vkontakte.'
    assert link.save, '1. Save new link with url and description'
    link.url = 'http://vk.com.ua/user1'
    assert link.save, '2. Save new link with url .com.ua and description'
    link.description = nil
    assert link.save, '3. Save new link with url .com.ua without description'

    link2 = SocialLink.new :url => 'https://plus.google.com/9fds0gdsfhdydfguser1/posts', :descriptoin => 'Lint to G+'
    assert link2.save, '4. Save new link with url g plus and description with sing +'
    link2.description = 'Some text and sings  - + # , . ( \'some text\' ).'
    assert link2.save, '5. check validation for description.'

    link3  = SocialLink.new :url => 'https://twitter.com/my_new_account', :descriptoin => 'I\'m in twitter'
    assert link3.save, '6. Save twitter link.'

    link3.url = 'http://my.social_link.com/(asdfasfasdasd)'
    assert !link3.save, '7. Save must be fail.'

    link.url = 'https://plus.google.com/nv4rtyr8v3rdsfsdhgfhfghgfhfghgjfgjbdybdrthbdtvrty4y45yvyw45vy4wfdsfsdfdsv3n8ry38vrn3yr83nyy8yr8vt48t234v8i34tn38y4tn28v3v4234t234t23mdt3248dt2342n3t4324t324t2384t324723hd23t4b7t432b4d27n237t49fds0gdsfhdydfddsfdsfsdfsdfdsfguser1/posts'
    assert !link.save, '8. Save must be fail. Too long'

    link2.description = 'Some text and sings gd sdf h ghsdfdsf fds fsd-g h gfh.'
    assert !link2.save, '9. Fail to save. Too long description'
  end

  test 'delete' do
    to_del = SocialLink.find(:id => 1)
    assert to_del.destroy, 'Remove link with id 1.'
  end
end
