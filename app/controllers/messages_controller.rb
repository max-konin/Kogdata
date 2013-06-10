class MessagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :user_check

  def show_all
    id = current_user.id
    @messages = Message.where('recipient_id = ?', id)
  end

  def show_dialog
    @sender_name = User.where('id = ?', message.sender_id).name
    id = current_user.id
    @messages = Message.where('recipient_id = ?', id,).where('sender_id = ?', params[:id])
  end

  def new_message

  end

  def create_message
    @message = Message.create(params[:message])
    redirect_to 'messages/show_all'
  end

  def delete_message
    Message.destroy(params[:id])
  end

  def user_check

  end
end
