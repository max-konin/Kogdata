class EventsController < ApplicationController
  before_filter :authenticate_user!
  def new
      @user = current_user
      format = "%FT%T.%LZ"
      stringTime = params[:events][:start]
      @event = @user.event.new(params[:events])
      @event.start = DateTime.strptime(stringTime,format)
      puts params[:events][:start]
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
    stringTime = params[:curDate]
    format = "%FT%T.%LZ"
    first_day = DateTime.strptime(stringTime,format)
    last_day = DateTime.strptime(stringTime,format)

    first_day = first_day.change({:day=> 1}).beginning_of_day
    last_day = last_day.at_end_of_month.end_of_day

    puts first_day
    puts last_day
    @events = Event.where("user_id = ? AND start > ? AND start < ? ",@user.id,first_day,last_day)
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