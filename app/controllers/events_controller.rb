class EventsController < ApplicationController
  before_filter :authenticate_user!
  def new
      @user = current_user
      @event = @user.events.create(params[:event])
      render '/calendar/index'
  end
end