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



end

