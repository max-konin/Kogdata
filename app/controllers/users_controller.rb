class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new

  end

  def create

  end

  def show
    redirect_to '/profile/'+params[:id]
  end

  def edit

  end

  def update

  end

  def destroy

  end
end
