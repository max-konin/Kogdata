class OfficeController < ApplicationController
  before_filter :authenticate_user!
  def all
    @event = Event.all
    respond_to do |format|
      format.html
      format.json {render :json => @event}
    end
  end

end