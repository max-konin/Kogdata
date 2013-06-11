class MessagesController < ApplicationController
  before_filter :authenticate_user!
 # before_filter :user_check

  def show_all
    @user = current_user
    @messages = @user.messages
  end

  def show_dialog
    @sender_name = User.where('id = ?', message.sender_id).name
    id = current_user.id
    @messages = Message.where('recipient_id = ?', id,).where('sender_id = ?', params[:id])
  end

  def new_message
    @message = Message.new()
    @recipient = params[:id]
  end

  def create_message
    @message = Message.new(params[:body])
    @message.was_seen = 0
    @message.sender_id = current_user.id
    @message.recipient_id = @recipient
    if @message.save
      redirect_to 'messages/show_all'
    else
      flash[:notice] = 'An error sending occurred'
    end
  end

  def delete_message
    Message.destroy(params[:id])
    redirect_to 'messages/show_all'
  end



  def user_check


  end
end
