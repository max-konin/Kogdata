class SocialLinksController < ApplicationController
  before_filter :authenticate_user!
  def index
    raise NotImplementedError
  end

  def new
    @social_link = SocialLink.new
    render :partial => 'social_links/form_add'
  end

  def create
    @user = current_user
    begin
      @social_link = @user.social_links.create!(params[:social_link])
      redirect_to :back
    rescue
      render 'users/edit'
    end
  end

  def destroy
    @user = current_user
    @social_link = @user.social_links.find(params[:id])
    @social_link.destroy
    redirect_to :back
  end
end
