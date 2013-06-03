class EventsController < ApplicationController
  before_filter :authenticate_user!
  def new
      @user = current_user
      @event = @user.event.new(params[:events])
      @event.save
      respond_to do |format|
        format.html
        format.json {render :json => @event}
        format.xml {render :xml => @event}
      end
      #head :ok
  end
  def all
    @user = current_user
    @events = Event.where("user_id = ?",@user.id)
    respond_to do |format|
      format.html
      format.json {render :json => @events}
      format.xml {render :xml => @event}
    end
  end
  def show
    @user = current_user
    @event = @user.event.find(params[:id])
    respond_to do |format|
      format.html
      format.json {render json:@event, :content_type => 'application/json'}
    end
  end
  def update
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
  end
end