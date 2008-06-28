# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
	filter_parameter_logging :password, :password_confirmation

  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    account = Account.find_by_subdomain(params[:subdomain] || (@account.subdomain != "www" ? @account.subdomain : ""))
    if !account.nil? && user = User.authenticate(account.id, params[:user][:email], params[:user][:password])
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      AuditLogin.record(user.id, params[:subdomain], params[:user][:email], account.id)
      if @account.subdomain != "www"
        redirect_back_or_default "http://#{base_url(account)}/sessions/jump?id=#{user.id}&key=#{user.generate_jump_token(15)}"
      else
        redirect_to "http://#{base_url(account)}/sessions/jump?id=#{user.id}&key=#{user.generate_jump_token(15)}"
      end
    else
      note_failed_signin
      @subdomain = account.subdomain
      @email       = params[:user][:email]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

  # for jumping across subdomains
  def jump
    if jump_login
      redirect_to :controller => "invoices", :action => ""
    end
  end

  def jump_from_signup
    if jump_login
      flash[:notice] = "Your account has been created! Welcome, and thanks for signing up with #{@app_config['app_name']}!" 
      redirect_to :controller => "invoices", :action => "create"
    end
  end
  

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Sorry, Couldn't log you in."
    logger.warn "Failed login for #{account.subdomain} with '#{params[:user][:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end

  def jump_login(account_id = @account.id)
    user = User.authenticate_by_jump_token(account_id, params[:id], params[:key])
    if user.nil?
      flash[:notice] = "Crumbs! - we tried to keep you logged on ... but failed. Please try logging in again."
      redirect_to :action => ''
      return false
    else
      self.current_user = user
      return true
    end
  end
end
