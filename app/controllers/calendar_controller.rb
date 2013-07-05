class CalendarController < ApplicationController
  def index
    if user_signed_in?
	    @user = current_user
	    cookies[:role] = @user.role
	    cookies[:user_id] = @user.id
    else
      redirect_to '/welcome/index'
    end
    @action = 'show-current'
  end

  def show_bookings
    if user_signed_in?
      @user = current_user
      cookies[:role] = @user.role
      cookies[:user_id] = @user.id
    end
    @action = 'show-bookings'
    render 'calendar/index'
  end

  def new_form
    render :partial => 'new_event'
  end

  def show_form
    @event_id = params[:event_id]
    render :partial => 'show_event'
  end
end
