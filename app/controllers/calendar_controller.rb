class CalendarController < ApplicationController
  def index
    if user_signed_in?
	    @user = current_user
	    cookies[:role] = @user.role
	    cookies[:user_id] = @user.id
    end
  end
end
