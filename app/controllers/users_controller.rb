class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [ :registration_after_omniauth, :create ]

  def index
    if params[:role].nil? then
      if current_user.role? :admin then
        @users = User.all
      else
        @users = User.where(:role => ['client', 'contractor']).limit(25)
      end
		session['search.offset'] = 20
		render
      return
    end

    if (User::ROLES.include? params[:role]) && (can_view_users_with_role? params[:role]) then
      @users = User.where(:role => params[:role])
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def show
    @user = User.find(params[:id])
    authorize! :read, @user
    respond_to do |format|
      format.html # users/show.html.haml
      format.json { render :json => @user }
    end
  end
  
  def search
	if not params[:again].nil? and params[:again] == 1
 		session['session.offset'] += 5
	else
		session['search.offset'] = 0
	_offset = session['search.offset']
	_input = params[:input]
	_contractor = params[:contractor].to_i
	_client = params[:client].to_i
	_role = [ 'contractor', 'client']
	if _contractor ^ _client == 1
		if _contractor == 1
			_role = [ 'contractor' ]
		else
			_role = [ 'client' ]
		end
	end
	@users = User.where('name like ? and (' + (['role = ?']*_role.size).join(' or ') + ')', "%#{_input}%", *_role).limit(5).offset(_offset)
	render :partial => "user_search_chunk", :locals => { :users => @users }
  end

  def destroy
    @user = User.find(params[:id])
    authorize! :destroy, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def edit
	 @user = current_user
	 render 'users/edit'
  end

  def update
	 if not current_user.role? params[:user][:role] and current_user.role? 'contractor' then
		Image.destroy_all :user_id => current_user.id
	 end
	 User.update current_user.id, params[:user]
	 redirect_to '/users/' + current_user.id.to_s
  end

  def registration_after_omniauth
	 @user = session['devise.omniauth_data']
	 if @user == nil
		redirect_to 'users/edit'
	 end
	 render 'users/after_omniauth', :layout => 'office'
  end

  def create
	 @user = User.new params[:user]
	 @user.save!
	 session['devise.omniauth_data'] = nil
	 sign_in_and_redirect @user
  end

  private
  def can_view_users_with_role? role
    if current_user.role? :admin then
      return true
    end
    if ['client', 'contractor'].include? role then
      return true
    end
    return false
  end
end
