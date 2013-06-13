class ConversationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :user_check

  def show
    @list = Conversation.where('id = ?', :id).messages
  end

  def delete
    delete all shit
  end

  def index
    @list = Array.new
    @conversations = current_user.conversations
    @conversations.each do |conversation|
      @last_msg = conversation.messages.last
      @list << {:msg => @last_msg, :id => conversation.id}
    end
  end

end

