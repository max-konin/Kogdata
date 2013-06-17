class UsersController < ApplicationController
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
