class CitiesController < ApplicationController
  #GET /cities.json
  def index
    @cities = City.all
    respond_to do |format|
      format.json { render json: @cities }
    end
  end
end