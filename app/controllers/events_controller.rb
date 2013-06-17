require 'Days'
class EventsController < ApplicationController
  before_filter :authenticate_user!
  def index
    #@user = current_user
    #the curDate parameter is a day of the current month
    #the event must be created by the current user and be booked on the current mobth
    puts '!!!!!!!!!!!!!!'
    puts params[:curDate] != nil
    if params[:curDate] != nil
      @eventsMonth = Event.where("user_id = ? AND start >= ? AND start <= ? ",@user.id, Days.firstDay(params[:curDate]),
                          Days.lastDay(params[:curDate]))
    end
    @eventsAll = Event.where("user_id = ?",params[:user_id])
    respond_to do |format|
      format.html {render :html => @eventsAll}
      format.json {render :json => @eventsMonth}
      format.xml {render :xml => @eventsAll}
    end
  end

  def new
      raise NotImplementedError
  end

  def create
      @user = current_user
      if Days.inMonth?(params[:events][:start],params[:curDate])
        @event = @user.event.create(params[:events])
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


  def show
    @user = current_user
    @event = Event.find(params[:id])
    puts '!!!!!!'
    puts @event.title
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

  def edit
    raise NotImplementedError
  end

  def destroy
    raise NotImplementedError
  end


end