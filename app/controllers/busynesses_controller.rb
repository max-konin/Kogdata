require 'Days'
class BusynessesController < ApplicationController
  before_filter :authenticate_user!

  def index
    user = User.find(params[:user_id])
    @bysunesess = user.busynesses.between(Days.firstDay(params[:curr_date]), Days.lastDay(params[:curr_date]))
    respond_to do |format|
      format.html {render 'calendar/index'}
      format.json {render :json =>@bysunesess}
    end
  end

  def create
    user_id = params[:user_id]
    @user = current_user
    @busyness = @user.busynesses.new
    currDate = params[:curr_date]
    date = params[:date]
    if current_user.id != Integer(user_id) || (cannot? :add, @busynesses)
      head :forbidden
      return false
    end
    if !Days.inMonth? date, currDate
      head :unprocessable_entity
      return false
    end
    @busyness.date = date
    if  @busyness.save!
      respond_to do |format|
        format.html {redirect_to 'calendar/index'}
        format.json {render :json => {:id => @busyness.id}, status: :ok}
      end
    else
      head :unprocessable_entity
    end
  end

  def destroy
    user_id = params[:user_id]
    @user = current_user
    bus_id = params[:id]
    if (Integer(user_id) != @user.id) || (!can? :add, @bysunesess)
      head :forbidden
      return false
    end
    if !@user.busynesses.exists? bus_id
      head :unprocessable_entity
      return false
    end
    @busyness = Busyness.find(bus_id)
    currDate = params[:curr_date]
    if !Days.inMonth? @busyness.date, currDate
      head :unprocessable_entity
      return false
    end
    if @busyness.destroy
      respond_to do |format|
        format.html {redirect_to 'calendar/index'}
        format.json {render :json => {}, status: :ok}
      end
    else
      head :unprocessable_entity
    end
  end
end