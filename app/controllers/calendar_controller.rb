class CalendarController < ApplicationController
	before_filter :authenticate_user!, :except => [:index]
	def index
		if user_signed_in?
      if current_user.role? :contractor
        redirect_to current_user
        return true
      end
			@user = current_user
			cookies[:role] = @user.role
			cookies[:user_id] = @user.id
		else
			redirect_to '/welcome'
		end
		@action = 'show-current'
    @event = Event.new
	end

	def show_bookings
		@user = current_user
		cookies[:role] = @user.role
		cookies[:user_id] = @user.id
		@action = 'show-bookings'
		render 'calendar/index'
	end

	def new_form
		render :partial => 'new_event'
	end

	def show_form
		@event_id = params[:event_id]
		@event = Event.find(@event_id)
		render :partial => 'show_event'
  end

  def get_contractor_navigation
    render :partial => 'users/contractor_calendar_type'
  end

	def set_busyness

	end
end
