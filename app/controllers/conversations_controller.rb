class ConversationsController < ApplicationController
  before_filter :authenticate_user!

  def create_message
    @conversation = (params[:id].nil?) ? Conversation.find_or_create_by_users(params[:members] + [current_user.id.to_s])
                                       : Conversation.find(params[:id])

    @message = @conversation.messages.create params[:message] do |message|
      message.was_seen = false
      message.user = current_user
    end

    redirect_to :back
  end

  def show
    @id = params[:id]
    @conversation = current_user.conversations.find_by_id(params[:id]).messages.reverse
  end

  def index
    @conversations = current_user.conversations.reverse
  end

  def delete_message
    current_user.messages.find_by_id(params[:id]).destroy

    redirect_to :back
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