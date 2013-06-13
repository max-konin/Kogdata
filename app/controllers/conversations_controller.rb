class ConversationsController < ApplicationController
  before_filter :authenticate_user!
  #before_filter :user_check

  #Create new conversation if its not be found and add new message
  def create_message
    #Unsafe code. Не придумал ничего лучше как руками написать sql запрос
    #TODO Написать нормальный код
    @conversation = Conversation.find_by_2_users(current_user.id, params[:contact_id]).first
    if @conversation.nil? then
      @conversation = current_user.conversations.build
      @conversation.users << User.find(params[:contact_id])
      @conversation.save!
    end
    message = @conversation.messages.build(params[:message])
    message.user = current_user
    message.save!
    redirect_to :back

  end

  def show
    @list = Conversation.where('id = ?', :id).messages
  end

  def delete
    #delete all shit
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

