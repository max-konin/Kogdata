class ConversationsController < ApplicationController
  before_filter :authenticate_user!

  def create_message

    compare_conversation!   #Creates a new conversation if it wasn't be found

    message = @conversation.messages.build(params[:message])
    message.user = current_user
    message.save!

    redirect_to :back
  end


  def show
    conv = Conversation.where('id = ?', :id)
    @list = conv.messages
    users = conv.users
    @u_n = Array.new
    users.each do |user|
      @u_n << user.name
    end
  end

  def index
    @list = Array.new
    @conversations = current_user.conversations
    @conversations.each do |conversation|
      @last_msg = conversation.messages.last
      @list << {:msg => @last_msg, :id => conversation.id}
    end
  end

  private
  def compare_conversation!
    members = params[:members]
    members << current_user.id.to_s
    members.sort!
    @hash = String.new
    members.each do |member|
      @hash += (member.to_s + ' ')               #makes hash string from accepted ids of declared members and current user id
    end

    @conversation = current_user.conversations.find_by_hash_string(@hash)

    if @conversation.nil? then
      @conversation = current_user.conversations.build              #creates a new conversation for current user if no matches found
      @conversation.hash_string = @hash
      params[:members].each do |member|
        @conversation.users << User.find(member)
      end
      @conversation.save!
    end


  end

end