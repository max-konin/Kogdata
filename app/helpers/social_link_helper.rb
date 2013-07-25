module SocialLinkHelper
  def get_link_by_provider(links, provider)
    links.each do |l|
      if l.provider == provider
        return l
      end
    end
    return SocialLink.new(:provider => provider)
  end

  def get_provider_link(provider)
    prov =
    case provider
      when 'vkontakte'
       'http://vk.com'
      when 'twitter'
        'http://twitter.com'
      when 'facebook'
       'http://facebook.com'
      when 'gplus'
       'http://plus.google.com'
      else ''
    end
  end

  def providers_list
    SocialLink::PROVIDERS
  end
end
