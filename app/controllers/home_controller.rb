class HomeController < ApplicationController
  before_filter :authenticate_user!
	
  def index
	debugger
	@user = current_user
  end
end
