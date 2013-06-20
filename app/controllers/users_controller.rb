class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    if params[:role].nil? then
      if current_user.role? :admin then
        @users = User.all
      else
        @users = User.where(:role => [:client, :contractor])
      end
      render
      return
    end

    if (User::ROLES.include? params[:role]) && (can_view_users_with_role? params[:role]) then
      @users = User.where(:role => params[:role])
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def show
    @user = User.find(params[:id])
    authorize! :read, @user
    respond_to do |format|
      format.html { render :layout => 'profile'}# users/show.html.haml
      format.json { render :json => @user }
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize! :destroy, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end



  private
  def can_view_users_with_role? role
    if current_user.role? :admin then
      return true
    end
    if ['client', 'contractor'].include? role then
      return true
    end
    return false
  end
end
