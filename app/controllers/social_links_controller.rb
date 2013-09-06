class SocialLinksController < ApplicationController
	before_filter :authenticate_user!
  load_and_authorize_resource
	def index
		@user = current_user
		@social_link = SocialLink.where('user_id = ?', @user.id)
		render :partial => '/social_links/form', :collection => @social_link
	end

	def create
    @social_link = (SocialLink.find_by_id params[:social_link][:id]) || current_user.social_links.build
    authorize! :create, @social_link
    begin
      @social_link.update_attributes! params[:social_link]
      respond_to do |format|
        format.html {redirect_to :back}
        format.json {render :json => {:social_link => @social_link, :success => 'yes'}}
      end
    rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
      respond_to do |format|
        format.html {redirect_to '/users/edit'}
        format.json {render :json => {:errors => @social_link.errors.messages}}
      end
    end
	end



	def destroy
		@user = current_user
		@social_link = @user.social_links.find(params[:social_link][:id])
		result = false
		if @social_link.destroy
			result = true
			@social_link = SocialLink.new(:provider => @social_link.provider)
		end
		error = false
		if result == false
			error = t(:delete_error)
		end
		if result
			respond_to do |format|
				format.html {redirect_to :back}
				format.json {render :json => {:social_link => @social_link, :success => 'yes'}}
			end
		else
			respond_to do |format|
				format.html {redirect_to :back}
				format.json {render :json => {:result => result, :error => {:cant_delete => error}}}
			end
		end
	end
end
