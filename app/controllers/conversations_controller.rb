class ConversationsController < ApplicationController
  before_filter :authenticate_user!

  def create_message

    compare_conversation   #Creates a new conversation if it wasn't be found

    message = @conversation.messages.build(params[:message])
    message.user = current_user
    message.save!

    redirect_to :back
  end


  def show
    @list = Conversation.where('id = ?', :id).messages
  end

  def index
    @list = Array.new
    @conversations = current_user.conversations
    @conversations.each do |conversation|
      @last_msg = conversation.messages.last.cut_body!
      @list << {:msg => @last_msg, :id => conversation.id}
    end
  end

  private
  def compare_conversation
    members = params[:members]
    members << current_user.id.to_s
    members.sort!
    @hash = String.new
    members.each do |member|
      @hash += (member.to_s + ' ')               #makes hash string from accepted ids of declared members and current user id
    end

    @conversation = current_user.conversations.where(:hash_string => @hash)

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

