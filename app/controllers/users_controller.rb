class UsersController < ApplicationController
	before_filter :authenticate_user!, :except => [ :registration_after_omniauth, :create ]

	def index
		if params[:role].nil? then
			if current_user.role? :admin then
				@users = User.all
			else
				@users = User.where(:role => ['client', 'contractor']).limit(40)
			end
			session['search.offset'] = 35
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
		_limit = 5
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
		if not params[:again].nil? and params[:again].to_i == 1
			session['search.offset'] += 5
		else
			session['search.offset'] = 0
			_limit = 40
		end
		_offset = session['search.offset']
		@users = User.where('name like ? and (' + (['role = ?']*_role.size).join(' or ') + ')', "%#{_input}%", *_role).limit(_limit).offset(_offset)
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
		@social_link = SocialLink.new(params[:social_link])
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
    @provider = session['devise.provider']
    if user_signed_in?
      if @provider.user_id.nil?
        @provider.user_id = current_user.id
        @provider.save!
        redirect_to :root
      else
        if @provider.user_id == current_user.id
          redirect_to :root
        else
          redirect_to '/users/merge'
        end
      end
    else
	    render '/users/after_omniauth', :layout => 'application'
    end
  end

	def create
		@user = User.new params[:user]
		if !params[:user][:avatar].nil?
			@user.avatar_url = ""
		end
		@provider = session['devise.provider']
		@user.save!
		unless @provider.nil?
			@provider.user_id = @user.id
			@provider.save!
		end
		session['devise.omniauth_data'] = nil
		sign_in_and_redirect @user
	end

  def merge
    @provider = session['devise.provider']
    @userNew = current_user
    @userOld = User.find(@provider.user_id)
    if @userOld.role != @userNew.role
      if @userNew.role == 'contractor'
        @images = @userNew.images
      end
      if @userOld.role == 'contractor'
        @images = @userOld.images
      end
    end
    render 'users/merge_form'
  end

  def merge_on_submit
    @provider = session['devise.provider']
    @userOld = User.find(@provider.user_id)
    @user = current_user

    case params['radio-name']
      when "old-name"
        @user.name = @userOld.name
      when "other-name"
        if !params['text-name'].blank?
          @user.name = params['text-name']
        else
          redirect_to :back
        end
    end

    case params['radio-email']
      when "old-email"
        @user.email = @userOld.email
      when "other-email"
       if !params['text-email'].blank?
         @user.email = params['text-email']
       else
         redirect_to :back
       end
    end

    if !params['radio-role'].blank?
      case params['radio-role']
        when "client-role"
          @user.role = "client"
          @user.images.destroy_all
          @user.price = nil
        when "contractor-role"
          if @user.role == 'client'
            @user.price = @userOld.price
          end
          @user.role = "contractor"
          @userOld.images.each do |image|
            image.user_id = @user.id
            image.save!
          end
      end
    end

    @userOld.event.each do |event|
      event.user_id = @user.id
      event.save!
    end

    @userOld.messages.each do |message|
      message.user_id = @user.id
      message.save!
    end

    @userOld.conversations.each do |conversation|
      hash_string = conversation.hash_string
      arr = hash_string.split
      arr.delete(@userOld.id.to_s)
      unless arr.include? @user.id.to_s
        arr.push @user.id.to_s
        arr.sort!
      end
      new_hash_string = ""
      arr.each do |id|
        new_hash_string += id+' '
      end
      conversation.hash_string = new_hash_string[0..-2]

      if conversation.valid?
        userConv = conversation.users
        userConv.delete(@userOld)
        unless userConv.include?(@user)
          userConv.push(@user)
        end
        conversation.save!
      else
        convExists = Conversation.where(:hash_string => conversation.hash_string).first
        conversation.messages.each do |message|
           message.conversation_id = convExists.id
        end
        conversation.destroy
      end
    end

    User.find(@userOld.id).destroy
    @user.save!
    redirect_to :root
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
