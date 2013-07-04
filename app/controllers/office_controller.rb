require 'Days'
class OfficeController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = current_user
    cookies[:role] = @user.role
	  cookies[:user_id] = @user.id
    render 'office/index'
  end

  def all
  @events = Event.where("start >= ? AND start <= ? ", Days.firstDay(params[:curDate]),
                        Days.lastDay(params[:curDate]))
  respond_to do |format|
    format.html {render :json => @events }
    format.json {render :json => @events}
    format.xml {render :xml => @events}
  end
end

  def portfolio
	 render 'image/_upload', :locals => { :user => current_user }
  end
end
