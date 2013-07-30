require 'Days'
class BusynessesController < ApplicationController
  before_filter :authenticate_user!
  def index
    user_id = params[:user_id]
    @bysunesess = Busyness.where('user_id = ? AND date >= ? AND date <= ?',user_id,Days.firstDay(params[:curr_date]),Days.lastDay(params[:curr_date]))
    respond_to do |format|
      format.html {render 'calendar/index'}
      format.json {render :json =>@bysunesess}
      format.xml {render :xml => @bysunesess}
    end
  end

  def create
    user_id = params[:user_id]
    @user = current_user
    @busyness = @user.busynesses.new
    if current_user.id == Integer(user_id) && (can? :add, @busynesses)
      currDate = params[:curr_date]
      date = params[:date]
      if Days.inMonth? date, currDate
        @busyness.date = date
        respond_to do |format|
          if  @busyness.save!
            format.html {render 'calendar/index'}
            format.json {render :json => {:id => @busyness.id}, status: :ok}
            format.xml {render :xml => {}, status: :ok}
          else
            format.html {render :html => @busyness.errors, status: :unprocessable_entity}
            format.json {render :json => @busyness.errors, status: :unprocessable_entity}
            format.xml {render :xml => @busyness.errors, status: :unprocessable_entity}
          end
        end
      else
        respond_to do |format|
          format.html {head :unprocessable_entity}
          format.json {render :json => {}, status: :unprocessable_entity}
          format.xml {render :xml => {},status: :unprocessable_entity}
        end
      end
    else
      respond_to do |format|
        format.html {head :forbidden}
        format.json {render :json => {}, status: :forbidden}
        format.xml {render :xml => {}, status: :forbidden}
      end
    end
  end


  def destroy
   puts '!!!!!'
  end
end