require 'Days'
class EventsController < ApplicationController
  before_filter :authenticate_user!
  #the curDate parameter is a day of the current month
  #the event must be created by the current user and be booked on the current month
  def index
    user = User.find params[:user_id]
    @events = user.event
    @events = @events.between(Days.firstDay(params[:curDate]), Days.lastDay(params[:curDate])) unless
        params[:curDate].nil?
    @events = @events.opened if params[:showClosed].nil? || !params[:showClosed]
    respond_to do |format|
      format.html {render :html => @events}
      format.json {render :json => @events}
      format.xml {render :xml => @events}
    end
  end

  def close
    @event = Event.find(params[:event_id])
    if @event.user_id == current_user.id && @event.closed.blank?
      @event.update_attribute(:closed,true)
      respond_to do |format|
        format.html {head :ok}
        format.json {head :ok}
        format.xml {head :ok}
      end
    else
      respond_to do |format|
        format.html {head :forbidden}
        format.json {render :json=> @event.errors, status: :forbidden}
      end
    end
  end

  def reopen
    @event = Event.find(params[:event_id])
    if @event.user_id == current_user.id && @event.closed == true
      @event.update_attribute(:closed,'')
      respond_to do |format|
        format.html {head :ok}
        format.json {head :ok}
        format.xml {head :ok}
      end
    else
      respond_to do |format|
        format.html {head :forbidden}
        format.json {render :json=> @event.errors, status: :forbidden}
      end
    end
  end

  def new
      raise NotImplementedError
  end

  def create
      @user = current_user
      if Days.inMonth?(params[:events][:start],params[:curDate])
        @event = @user.event.create!(params[:events])
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

  #TODO: inspect usage
  def show
    @user = current_user
    @event = Event.find(params[:id])
		@response = @event.responses.where('user_id = ?', @user.id).first
		respond_to do |format|
      format.html
      format.json {render json:@event, :content_type => 'application/json'}
    end
  end

  def update
    if Days.inMonth?(params[:events][:start],params[:curDate])
      @event = Event.find(params[:id])
      if @event.user_id == current_user.id
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
          format.html {head :forbidden}
          format.json {render :json=> @events.errors, status: :forbidden}
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
