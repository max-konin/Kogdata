class EventsController < ApplicationController

  def new
    @user = current_user
    @event = @user.event.create(params[:event])

  end
end