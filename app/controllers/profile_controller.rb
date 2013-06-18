class ProfileController < ApplicationController
  def show
    @user = User.find(params[:id])
    if @user.role=='contractor'
      @images = @user.images
    end
    if @user.role == 'client'
      @events = @user.event.all
    end
    render 'profile/index'
  end
end