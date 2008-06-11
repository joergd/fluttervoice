class PeopleController < ApplicationController
  before_filter :login_required
  before_filter :user_limit_reached?, :only => [:new]
  after_filter :store_location, :except => [:edit, :new]

  def index
    @user = current_user
  end

  def new
    # id represents the client id.
    # if it is empty, then we are creating a user for the account
    if params[:id].nil?
      if !primary_user?
        logger.error("Attempt for non-primary user to add a user")
        flash[:notice] = "You need to be the main user of the account to be able to add additional people for your account"
        redirect_back_or_default
        return
      end
      @person = User.new
    else
      # verify that client belongs to account
      client = our_client(params[:id])
      return if client.nil?

      @person = Contact.new
    end

    if request.get?
      return
    end

    # we reach this part if it was a POST and everything so far is cool
    @person.attributes = params[:person].merge(audit_create_trail)
    @person.account_id = @account.id
     @person.client_id = params[:id].nil? ? 0 : params[:id]

    if @person.save
      flash[:notice] = 'Person was successfully added.'
      redirect_back_or_default
    end
  end

  def edit
     @person = our_person(params[:id])
     return if @person.nil?

    # make sure only the primary user can edit details, or
    # the logged in user can change their own details
    # or the person being edited is a client
    if !primary_user? && current_user.id != @person.id && @person.user?
      logger.error("Attempt to access protected person #{params[:id]}")
      flash[:notice] = "You need to be the main user to be able to edit #{@person.firstname}'s details"
      redirect_back_or_default
      return
    end

    # we haven't changed any info yet, so just show the form
    if request.get?
      return
    end

    # if we filled out the password field, then do the password validations and salt etc
    if @person.user? && params[:person][:password].length > 0
      @person.change_password(params[:person][:password], params[:person][:password_confirmation])
    end

    # attempt to save the updated fields
    if @person.update_attributes(params[:person].merge(audit_update_trail))
      if current_user.id == @person.id
        session[:user] = @person
      end
      flash[:notice] = 'Person was successfully updated.'
      redirect_back_or_default
    end

  end

  def delete
    if !primary_user?
      logger.error("Attempt for non-primary user to delete person #{params[:id]}")
      flash[:notice] = "You need to be the main user to be able to delete people."
      redirect_back_or_default
      return
    end

    person = our_person(params[:id])
    return if person.nil?

    person.destroy
    redirect_back_or_default
  end
end
