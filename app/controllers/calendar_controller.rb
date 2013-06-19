class CalendarController < ApplicationController
  def index
   debugger
	@user = current_user
	cookies[:role] = @user.role
	cookies[:user_id] = @user.id
  end
end
