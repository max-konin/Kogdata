class OfficeController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = current_user
    cookies[:role] = @user.role
    render 'office/index'
  end

  def all
    events = Event.all
    respond_to do |format|
      format.html
      format.json {render :json => events}
    end
  end

  def portfolio
	 render 'image/_upload', :locals => { :user => current_user }
  end
end
