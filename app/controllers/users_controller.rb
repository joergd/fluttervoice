class UsersController < ApplicationController

  def forgot_password
    # Always redirect if logged in
    if logged_in?
      flash[:notice] = "You are currently logged in"
      redirect_to login_url
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
        #begin
          User.transaction do
            key = user.generate_jump_token
            url = url_for(:action => 'change_password')
            url += "?id=#{user.id}&key=#{key}"
            UserNotify.deliver_forgot_password(url, user, account, @app_config)
            flash[:notice] = "Instructions on resetting your password have been emailed to #{params[:user][:email]}"
            redirect_to login_url unless logged_in?
            redirect_back_or_default :controller => 'invoices', :action => '' if logged_in?
          end
        #rescue
        #  flash[:notice] = "Your password could not be emailed to #{params[:user][:email]}."
        #end
      end
    end
  end

  def change_password
    @user = User.authenticate_by_jump_token(@account.id, params[:id], params[:key])
    if @user.nil?
      flash[:notice] = "Either your security token has expired, or your security token is invalid. You requested to reset your password quite some time ago. Unfortunately the security token that we generate for you is only active for about 24 hours. Best is just to click on the Forgotten Password link again, or to make sure the link in your email didn't span two lines and got chopped in half."
      redirect_to login_url
      return
    end

    if request.post?
      @user.change_password(params[:user][:password], params[:user][:password_confirmation])
      if @user.save
        self.current_user = @user
        AuditLogin.record(@user.id, @account.subdomain, @user.email, @account.id)
        flash[:notice] = "We've updated your password, and you are logged in."
        redirect_back_or_default :controller => 'invoices', :action => ''
        return
      else
        flash[:notice] = "We couldn't update your password - please ensure that you have entered it correctly twice."
      end
    end
  end

end
