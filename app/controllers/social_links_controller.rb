class SocialLinksController < ApplicationController
	before_filter :authenticate_user!
	def index
		@user = current_user
		@social_link = SocialLink.where('user_id = ?', @user.id)
		render :partial => '/social_links/form', :collection => @social_link
	end

	def new
		@user = current_user
		@social_link = SocialLink.new()
		render :partial => '/social_links/form'
	end

	def create
		@user = current_user
		result = false
		begin
			@social_link = @user.social_links.find(params[:social_link][:id])
			if params[:social_link][:url].strip.length == 0
				result = @social_link.destroy
				if result
					@social_link = SocialLink.new(:provider => @social_link.provider)
				end
			else
				result = @social_link.update_attributes(params[:social_link])
			end
		rescue ActiveRecord::RecordNotFound
			@social_link = @user.social_links.new(params[:social_link])
			if params[:social_link][:url].strip.length != 0
				result = @social_link.save
			end
		rescue Exception do |exception|
			logger.error "rescued_from:: #{params[:controller]}##{params[:action]}: #{exception.inspect}\n"
			end
		end

		if result
			respond_to do |format|
				format.html {redirect_to :back}
				format.json {render :json => {:social_link => @social_link, :success => 'yes'}}
			end
		else
			respond_to do |format|
				format.html {redirect_to '/users/edit'}
				format.json {render :json => {:errors => @social_link.errors.messages}}
			end
		end
	end



	def destroy
		@user = current_user
		@social_link = @user.social_links.find(params[:id])
		result = false
		if @social_link.destroy
			result = true
		end
		error = false
		if result == false
			error = t(:delete_error)
		end
		respond_to do |format|
			format.html {redirect_to :back}
			format.json {render :json => {:result => result, :error => error}}
		end
	end
end
