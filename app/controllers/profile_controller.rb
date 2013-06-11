class ProfileController < ApplicationController
  def show
    @user = User.find(params[:id])
    render 'profile/index'
  end
end