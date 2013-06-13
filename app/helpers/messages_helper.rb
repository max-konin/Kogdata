module MessagesHelper
  def cut_body!(message)
    if message.body.to_s.lenght >= 120 then
      message.body.to_s.str[0, 119]
    end
  end

end
