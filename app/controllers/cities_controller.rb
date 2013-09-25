#class PostsController < ApplicationController
#  http_basic_authenticate_with :name => "dhh", :password => "secret", :except => [:index, :show]
#  # GET /posts
#  # GET /posts.json
#  def index
#    page_num = (params[:page].blank?) ? 1 : Integer(params[:page])
#    puts page_num
#    @posts = Post.limit(5).offset((page_num - 1) * 5)
#    respond_to do |format|
#      format.html # index.html.erb
#      format.json { render json: @posts }
#    end
#  end
class CitiesController < ApplicationController
  #GET /cities.json
  def index
    @cities = City.all
    respond_to do |format|
      format.json { render json: @cities }
    end
  end
end