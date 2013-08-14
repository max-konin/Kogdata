class ResponsesController < ApplicationController
	before_filter :authenticate_user!

	def index
		@event = Event.find(params[:event_id])
		if current_user.id != @event.user_id
			 throw 'access denied'
		end
		@responses = @event.responses
	end

  def show
		@respones = Response.where('user_id = ? and status IN (\'confirmed\', \'submitted\')', params[:user_id])
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
				format.json {render :json => {:success => 'yes', :response => @response}}
			end
		else
			respond_to do |format|
				format.html {redirect_to @event}
				format.json {render :json => {:errors => @response.errors.messages}}
			end
		end
  end

  def update
		@response = Response.find(params[:id])
		if @response.update_attributes(params[:response])
			respond_to do |format|
				format.html {redirect_to '/events/' + @response.event_id.to_s}
				format.json {render :json => {:success => 'yes'}}
			end
		else
			respond_to do |format|
				format.html {redirect_to '/events/' + @response.event_id.to_s}
				format.json {render :json => {:errors => @response.errors.messages}}
			end
		end
  end

  def destroy
		@response = Response.find(params[:id])
		if @response.destroy
			respond_to do |format|
				format.html {redirect_to '/events/' + @response.event_id.to_s}
				format.json {render :json => {:success => 'yes'}}
			end
		else
			respond_to do |format|
				format.html {redirect_to '/events/' + @response.event_id.to_s}
				format.json {render :json => {:errors => @response.errors.messages}}
			end
		end
  end
end
