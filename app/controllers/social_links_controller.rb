class SocialLinksController < ApplicationController
  before_filter :authenticate_user!
  def index
    raise NotImplementedError
  end

  def new
    @social_link = SocialLink.new()
    render :partial => 'social_links/form_add'
  end

  def create
    @user = current_user
    # Separate object @social_link for not display this link in list links /app/views/social_links/_social_link.html.haml
    # form view /app/views/users/edit.html.haml
    @social_link = SocialLink.new(params[:social_link])
    @social_link.user_id = @user.id
    if @social_link.save
      redirect_to :back
    else
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
