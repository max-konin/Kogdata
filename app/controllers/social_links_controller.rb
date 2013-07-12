class SocialLinksController < ApplicationController
  before_filter :authenticate_user!
  def index
    redirect_to '/users/edit'
  end

  def new
    @social_link = SocialLink.new()
    render :partial => '/social_links/form_add'
  end

  def create
    @user = current_user
    # Separate object @social_link for not display this link in list links /app/views/social_links/_social_link.html.haml
    # form view /app/views/users/edit.html.haml
    @social_link = SocialLink.new(params[:social_link])
    @social_link.user_id = @user.id
    if @social_link.save
      respond_to do |format|
        format.html {redirect_to :back}
        format.json {render :json => @social_link}
      end
    else
      respond_to do |format|
        format.html {redirect_to '/users/edit'}
        format.json {render :json => {:errors => @social_link.errors.messages}}
      end
    end
  end

  def destroy
    @user = current_user
    @social_link = @user.social_links.find(params[:id])
    result = false
    if @social_link.destroy
      result = true
    end
    error = false
    if result == false
      error = t(:delete_error)
    end
    respond_to do |format|
      format.html {redirect_to :back}
      format.json {render :json => {:result => result, :error => error}}
    end
  end
end
