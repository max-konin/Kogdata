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
    @conversation = current_user.conversations.find_by_id(params[:id])
  end

  def index
    @conversations = current_user.conversations.reverse
  end

  def delete_message
    current_user.messages.find_by_id(params[:m_id]).destroy

    redirect_to :back
  end


end