class ConversationsController < ApplicationController
  before_filter :authenticate_user!

  def create_message

    find_or_create_conversation!   #Creates a new conversation if it wasn't be found

    message = @conversation.messages.build(params[:message])
    message.user = current_user
    message.save!

    redirect_to :back

  end


  def show

    @list = Array.new
    conversation = current_user.conversations.find_by_id(params[:id])
    conversation.messages.reverse.each do |msg|
      @list << {:user => msg.user, :msg => msg}
    end
    @id = params[:id]

  end

  def index

    @list = Array.new
    conversations = current_user.conversations
    conversations.reverse.each do |conversation|
      message = conversation.messages.last
      @list << {:msg => message, :conv => conversation, :user => message.user}
    end

  end

  private

  def find_or_create_conversation!

    if params[:id].nil? then
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
    else
      @conversation = current_user.conversations.find_by_id(params[:id])
    end
  end

end