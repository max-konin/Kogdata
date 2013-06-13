class ProfileController < ApplicationController
  def show
    @user = User.find(params[:id])
    @images = @user.images
    puts '!!!!!!!!!!!!!'
    puts @images
    render 'profile/index'
  end
end