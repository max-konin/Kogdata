module ConversationsHelper

  def compare_conversation

    members = params[:members]
    members << current_user.id
    members.sort!
    members.each do |member|
      @hash += (member.to_s + ' ')               #makes hash string from accepted ids of declared members and current user id
    end

    @conversation = current_user.converstaions.where(:hash_string => @hash)

    #@cu_convs.each do |conv|                     #compares new hash string with ones from database
    #  if conv.hash_string == @hash then
    #    @conversation = conv
    #  end
    #end

        if @conversation.empty? then
      @conversation = @cu_convs.build              #creates a new conversation for current user if no matches found
      params[:members].each do |member|
        @conversation.users << User.find(member)
      end
      @conversation.save!
    end

  end

end

