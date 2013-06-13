require 'Days'
class EventsController < ApplicationController
  before_filter :authenticate_user!
  def new
      @user = current_user
      if Days.inMonth?(params[:events][:start],params[:curDate])
        @event = @user.event.new(params[:events])
        @event.save
        respond_to do |format|
          format.html
          format.json {render :json => @event}
          format.xml {render :xml => @event}
        end
      else
        respond_to do |format|
          format.html
          format.json {render :json=>{ }, status: :bad_request}
        end
      end

  end
  def all
    @user = current_user
    #the curDate parameter is a day of the current month
    #the event must be created by the current user and be booked on the current mobth
    @events = Event.where("user_id = ? AND start >= ? AND start <= ? ",@user.id, Days.firstDay(params[:curDate]),
    Days.lastDay(params[:curDate]))
    respond_to do |format|
      format.html
      format.json {render :json => @events}
      format.xml {render :xml => @event}
    end
  end

  def show
    @user = current_user
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html
      format.json {render json:@event, :content_type => 'application/json'}
    end
  end

  def update
    if Days.inMonth?(params[:events][:start],params[:curDate])
      @event = Event.find(params[:id])
      respond_to do |format|
        if @event.update_attributes(params[:events])
          format.html
          format.json { render :json => true}
        else
          format html
          format.json {render json=> @events.errors, status: :unprocessable_entity}
        end
      end
    else
      respond_to do |format|
        format.html
        format.json {render :json=>{ }, status: :bad_request}
      end
    end
  end
end