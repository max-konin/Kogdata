require 'Days'
class EventsController < ApplicationController
  before_filter :authenticate_user!
  def index
    #@user = current_user
    #the curDate parameter is a day of the current month
    #the event must be created by the current user and be booked on the current month
    if params[:curDate] != nil
      @events = Event.where("user_id = ? AND start >= ? AND start <= ? ",params[:user_id], Days.firstDay(params[:curDate]),
                          Days.lastDay(params[:curDate]))
    else
      @events = Event.where("user_id = ?",params[:user_id])
    end
    respond_to do |format|
      format.html {render :html => @events}
      format.json {render :json => @events}
      format.xml {render :xml => @events}
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
          format.html {head :ok}
          format.json {render :json => @event}
          format.xml {render :xml => @event}
        end
      else
        respond_to do |format|
          format.html {head :bad_request}
          format.json {render :json=>{ }, status: :bad_request}
        end
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
          format.html {head :ok}
          format.json { render :json => true}
        else
          format.html {head :unprocessable_entity}
          format.json {render :json=> @events.errors, status: :unprocessable_entity}
        end
      end
    else
      respond_to do |format|
        format.html {head :unprocessable_entity}
        format.json {render :json=>{ }, status: :unprocessable_entity}
      end
    end
  end

  def respond
    @event = Event.find(params[:event_id])
    conversation = Conversation.find_or_create_by_users [current_user.id, @event.user_id]
    conversation.messages.create (params[:message]) do |m|
      m.user = current_user
      m.event = @event
    end
    redirect_to :back
  end

  def edit
    raise NotImplementedError
  end

  def destroy
    raise NotImplementedError
  end


end
