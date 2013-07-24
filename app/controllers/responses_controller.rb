class ResponsesController < ApplicationController
  def index
	end

  def create
		@event = Event.find(params[:event_id])
		@response = @event.responses.new(params[:response])
		unless current_user.role == 'contractor' or current_user.id === params[:response][:user_id]
			throw 'error'
		end
		if @response.save
			respond_to do |format|
				format.html {redirect_to event_url(@event)
				}
				format.json {render :json => {:status => 'yes', :response => @response}}
			end
		else
			respond_to do |format|
				format.html {redirect_to @event}
				format.json {render :json => {:errors => @response.errors.messages}}
			end
		end
  end

  def update
		@response = Response.find(params[:response_id])
		if @response.update_attributes(params[:responses])
			respond_to do |format|
				format.html {redirect_to 'events/show'}
				format.json {render :json => {:status => 'yes'}}
			end
		else
			respond_to do |format|
				format.html {redirect_to 'events/show'}
				format.json {render :json => {:errors => @response.errors.messages}}
			end
		end
  end

  def delete
		@response = Response.find(params[:response_id])
		if @response.destroy
			respond_to do |format|
				format.html {redirect_to 'events/show'}
				format.json {render :json => {:status => 'yes'}}
			end
		else
			respond_to do |format|
				format.html {redirect_to 'events/show'}
				format.json {render :json => {:errors => @response.errors.messages}}
			end
		end
  end
end
