class CalendarController < ApplicationController
  def index
	@user = current_user
	cookies[:role] = @user.role
	cookies[:user_id] = @user.id
  puts '!!!!!!!!!!!'
  puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
  puts @user.id
  end
end
