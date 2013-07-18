class CalendarController < ApplicationController
	before_filter :authenticate_user!, :except => [:new_form, :show_form]

	def index
		@user = current_user
		cookies[:role] = @user.role
		cookies[:user_id] = @user.id
		@action = 'show-current'
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

	def set_busyness

	end
end
