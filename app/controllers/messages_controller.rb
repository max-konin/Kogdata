class MessagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :user_check

  def show_all
    @user = current_user
    @messages = @user.received_messages
  end

  def show_dialog
    @user = current_user
    @messages = @user.received_messages.where('user_sender_id = ?', :id)
  end
 #TODO: Переписать говно-код
  def new_message
    #@message = Message.new
    @message = current_user.sent_messages.build
    @message.recipient = User.find(params[:recipient_id])
  end

  def create_message
    @message = Message.new(params[:message])
    @message.recipient = User.find(params[:recipient_id])
    @message.was_seen = 0
    #@message.user_sender_id = current_user.id

    if @message.save
      redirect_to :action => 'show_all'
    else
      flash[:notice] = 'An error sending occurred'
    end
  end

  def delete_message
    Message.destroy(params[:id])
    redirect_to 'messages/show_all'
  end

  #END TODO

  def user_check
    @request_user = User.find(params[:user_id])
    redirect_to root_path unless (current_user == @request_user)
  end
end
