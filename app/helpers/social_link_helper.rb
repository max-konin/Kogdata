module SocialLinkHelper
  def get_provider(url)
    res = url.scan(/\A(https?:\/\/([\w-]+\.)?[\w-]+\.\w+(\.\w+)?).*\z/)
    if res
      res.first.first
    end
  end
end
