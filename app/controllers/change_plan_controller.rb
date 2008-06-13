class ChangePlanController < ApplicationController
  before_filter :login_required, :except => [:approved, :not_approved]

  # return-to accounts on own site
  # have to implement it here as opposed to a direct /login/jump url,
  # as the security token for the jump expires after 15seconds
  # so generate it here, and redirect to the jump
  def cancel
    account = Account.find_by_id_and_primary_person_id(session[:account_id], current_user.id)
    redirect_to "http://#{base_url(account)}/login/jump_to_account?id=#{current_user.id}&key=#{current_user.generate_security_token(15)}"  
  end
  
  def free
    @nonav = true # don't show nav menu
    @plan = Plan.find(Plan::FREE)
    if request.post?
      @account.plan = @plan
      if @account.save
        send_downgrade_to_free(account)
        flash[:notice] = "You have successfully downgraded your account."
        redirect_to :controller => "account", :action => ""
      else
        begin
          raise RuntimeError, "Couldn't upgrade/downgrade account"
          rescue RuntimeError => e
            logger.error("MAJOR BALLS UP")
            ExceptionNotifier.deliver_exception_notification(e, self, request, { :account => account })
            flash[:error] = "Your credit card was NOT charged, but there was a problem upgrading/downgrading your account. An email has been sent to us to rectify the problem. Please send us an email as well so that we can sort it out ASAP. Really sorry about this."
        end
        return false
      end
    end
  end
  
  def lite
    @plan = Plan.find(Plan::LITE)
  end
  
  def hardcore
    @plan = Plan.find(Plan::HARDCORE)
  end
  
  def ultimate
    @plan = Plan.find(Plan::ULTIMATE)
  end

  # This is called from VCS if the CC payment has been approved
  # See if _form and the VCS documentation what parameters are returned
  def approved
    @account = Account.find_by_id(params[:m_1])
  end

  # This is called from VCS if the CC payment has been approved
  # See if _form and the VCS documentation what parameters are returned
  def approved
    @account = Account.find_by_id(params[:m_1])
    @plan = Plan.find_by_id(params[:m_2])
  end

  # This is called from VCS if the CC payment has been approved
  # See if _form and the VCS documentation what parameters are returned
  def not_approved
    @account = Account.find_by_id(params[:m_1])
  end

private

  def send_downgrade_to_free(account)
    begin
      SystemMailer.deliver_downgrade_to_free(:from => "#{@app_config['system_email']}", :account => account, :home_url => "www.#{@app_config['domain']}")
    rescue
      logger.error("Error sending downgrade to free email")
      logger.error($!)
      ExceptionNotifier.deliver_exception_notification($!, self, request)
    end
  end

end
