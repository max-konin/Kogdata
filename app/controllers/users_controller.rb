class UsersController < ApplicationController
  def index

  end

  def new

  end

  def create

  end

  def show
    redirect_to 'profile/'+params[:user_id]
    puts '!!!!!!!!!'
    puts params
  end

  def edit

  end

  def update

  end

  def destroy

  end
end
