class LoginController < ApplicationController

  def index
    current_user = nil
    if request.get?
      @user = User.new
      return
    end
    unless params[:user].nil?
      account = Account.find_by_subdomain(params[:subdomain] || (@account.subdomain != "www" ? @account.subdomain : ""))
      if !account.nil? && user = User.authenticate(account.id, params[:user][:email], params[:user][:password])
        session[:user] = user
        AuditLogin.record(user.id, params[:subdomain], params[:user][:email], account.id)
        if @account.subdomain != "www"
          redirect_back_or_default "http://#{base_url(account)}/login/jump?id=#{user.id}&key=#{user.generate_security_token(15)}"
        else
          redirect_to "http://#{base_url(account)}/login/jump?id=#{user.id}&key=#{user.generate_security_token(15)}"
        end
      else
        AuditLogin.record_failure(params[:subdomain], params[:user][:email], (account.nil? ? nil : account.id))
        flash[:notice] = "Sorry, your log-in attempt was unsuccessful"
      end
    end
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
      redirect_to :controller => "invoices", :action => ""
    end
  end
  
  def jump_from_change_plan
    if jump_login
      flash[:notice] = "Your account plan has been changed!" 
      redirect_to :controller => "account", :action => ""
    end
  end

  def jump_to_change_plan
    if jump_login(params[:account_id])
      session[:account_id] = params[:account_id]
      session[:return_to] = url_for :controller => "change_plan", :action => "cancel", :protocol => "http://", :only_path => false
      redirect_to :controller => "change_plan", :action => Plan.find(params[:plan_id]).name.downcase
    end    
  end
  
  def jump_to_account
    if jump_login
      redirect_to :controller => "account", :action => ""
    end
  end
  
  def forgot_password
    # Always redirect if logged in
    if user?
      flash[:notice] = "You are currently logged in"
      redirect_to :action => ''
      return
    end

    if request.post?
      if params[:user][:email].empty?
        flash[:notice] = "Please enter a valid email address."
      elsif (account = Account.find_by_subdomain(params[:subdomain])).nil?
        flash[:notice] = "We could not find an account with the name of #{params[:subdomain]}"
      elsif (user = User.find_by_account_id_and_email(account.id, params[:user][:email])).nil?
        flash[:notice] = "We could not find a user with the email address #{params[:user][:email]}"
      else
        begin
          User.transaction do
            key = user.generate_security_token
            url = url_for(:action => 'change_password')
            url += "?id=#{user.id}&key=#{key}"
            UserNotify.deliver_forgot_password(url, user, account, @app_config)
            flash[:notice] = "Instructions on resetting your password have been emailed to #{params[:user][:email]}"
            redirect_to :action => '' unless user?
            redirect_back_or_default :controller => 'invoices', :action => '' if user?
          end
        rescue
          flash[:notice] = "Your password could not be emailed to #{params[:user][:email]}."
        end
      end
    end
  end

  def change_password
    @user = User.authenticate_by_token(@account.id, params[:id], params[:key])
    if @user.nil?
      flash[:notice] = "Either your security token has expired, or your security token is invalid. You requested to reset your password quite some time ago. Unfortunately the security token that we generate for you is only active for about 24 hours. Best is just to click on the Forgotten Password link again, or to make sure the link in your email didn't span two lines and got chopped in half."
      redirect_to :action => ''
      return
    end

    if request.post?
      @user.change_password(params[:user][:password], params[:user][:password_confirmation])
      if @user.save
        session[:user] = @user
        AuditLogin.record(@user.id, @account.subdomain, @user.email, @account.id)
        flash[:notice] = "We've updated your password, and you are logged in."
        redirect_back_or_default :controller => 'invoices', :action => ''
        return
      else
        flash[:notice] = "We couldn't update your password - please ensure that you have entered it correctly twice."
      end
    end
  end

private

  def jump_login(account_id = @account.id)
    user = User.authenticate_by_token(account_id, params[:id], params[:key])
    if user.nil?
      flash[:notice] = "Crumbs! - we tried to keep you logged on ... but failed. Please try logging in again."
      redirect_to :action => ''
      return false
    else
      session[:user] = user
      return true
    end
  end
end
