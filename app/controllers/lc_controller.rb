class LcController < ApplicationController
  before_filter :authenticate_user!, only: [:show_all, :create_msg, :delete_msg, :profile_update]

  def index
    if !(user_signed_in?)
      flash[:notice] = "You have not permission to view this page, sign in please."
      redirect_to '/users/sign_in'
    end
  end

  def show_all
    @user = current_user
    id = current_user.attributes['id']
    @messages = Message.where('recipient_id = ?', id)
  end

  def create_msg
    redirect_to 'lc/new'
  end

  def delete_msg
    @user = User.find(param[:id])

    user.messages
    redirect_to @messages
  end

  def profile_update
  end
end
