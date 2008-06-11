class ChangePlanController < ApplicationController
  before_filter :login_required
  layout "signup"

  def jump
    if false && ENV['RAILS_ENV'] == 'production'
      flash[:notice] = "The paid plans are not yet available ... still busy hooking it all up to a bank."
      redirect_to :controller => "account", :action => ""
      return 
    end
    protocol = ENV['RAILS_ENV'] == "http://" # 'production' ? "https://" : "http://"
    redirect_to "#{protocol}www.#{@app_config['domain']}/login/jump_to_change_plan?id=#{current_user.id}&key=#{current_user.generate_security_token(15)}&account_id=#{@account.id}&plan_id=#{params[:id]}"
  end

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
    @account = Account.find_by_id_and_primary_person_id(session[:account_id], current_user.id)
    @plan = Plan.find(Plan::FREE)
    if request.post?
      @account.validate_cc = false
      @account.plan = @plan
      if @account.save
        audit_free_change_plan(account, current_user)
        send_downgrade_to_free(account)
        redirect_to_account(@account)
        reset_session
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
    @account = Account.find_by_id_and_primary_person_id(session[:account_id], current_user.id)
    if change_plan_to(@account, Plan::LITE)
      redirect_to_account(@account)
      reset_session
    end
  end
  
  def hardcore
    @account = Account.find_by_id_and_primary_person_id(session[:account_id], current_user.id)
    if change_plan_to(@account, Plan::HARDCORE)
      redirect_to_account(@account)
      reset_session
    end
  end
  
  def ultimate
    @account = Account.find_by_id_and_primary_person_id(session[:account_id], current_user.id)
    if change_plan_to(@account, Plan::ULTIMATE)
      redirect_to_account(@account)
      reset_session
    end
  end

private

  def redirect_to_account(account)
    redirect_to "http://#{base_url(account)}/login/jump_from_change_plan?id=#{current_user.id}&key=#{current_user.generate_security_token(15)}"
  end
  
  def audit_paid_change_plan(account, user, amount, order_number)
    begin
      AuditChangePlan.record_paid(account.subdomain, user.email, @app_config['site'], request.remote_ip, account.plan.name,
                              account.cc_name, account.cc_address1, account.cc_address2, account.cc_city, account.cc_postalcode, account.cc_country,
                              account.cc_type, account.cc_last_4_digits, account.cc_expiry, account.currency, amount, order_number)
    rescue
      logger.error("Error auditing paid change plan")
      logger.error($!)
      ExceptionNotifier.deliver_exception_notification($!, self, request)
    end
  end

  def audit_free_change_plan(account, user)
    begin
      AuditChangePlan.record_free(account.subdomain, user.email, @app_config['site'], request.remote_ip)
    rescue
      logger.error("Error auditing free change plan")
      logger.error($!)
      ExceptionNotifier.deliver_exception_notification($!, self, request)
    end
  end

  def send_invoice(account, order_number)
    begin
      SystemMailer.deliver_invoice(:from => "#{@app_config['system_email']}", :account => account, :order_number => order_number, :amount => account.plan.cost(@app_config['site']), :home_url => "www.#{@app_config['domain']}")
    rescue
      logger.error("Error sending invoice email")
      logger.error($!)
      ExceptionNotifier.deliver_exception_notification($!, self, request)
    end
  end

  def send_downgrade_to_free(account)
    begin
      SystemMailer.deliver_downgrade_to_free(:from => "#{@app_config['system_email']}", :account => account, :home_url => "www.#{@app_config['domain']}")
    rescue
      logger.error("Error sending downgrade to free email")
      logger.error($!)
      ExceptionNotifier.deliver_exception_notification($!, self, request)
    end
  end

  def change_plan_to(account, plan_id)
    @nonav = true # don't show nav menu
    @plan = Plan.find(plan_id)

    if request.post?

      account.plan = @plan
      
      if !params[:cc_use_cross_reference]
        account.attributes = params[:account]
        account.validate_cc = true
        return false if !account.valid?
    
        @creditcard = PaymentGateway::creditcard(account)
        return false if !@creditcard.valid?

        payment_result, cc_transaction = PaymentGateway.take_recurring_payment(
                      account,
                      @app_config['currency_to_bill'],
                      account.plan.cost(@app_config['site']),
                      @creditcard)
    
        if !payment_result.success?
          flash[:cc_error] = payment_result.message
          return false
        end

        account.vp_cross_reference = cc_transaction.vp_cross_reference
        account.cc_last_4_digits = cc_transaction.cc_last_4_digits
        account.currency = cc_transaction.currency

      elsif !account.vp_cross_reference.blank?
        payment_result, cc_transaction = PaymentGateway.take_recurring_repeat_payment(
                      account,
                      @app_config['currency_to_bill'],
                      account.plan.cost(@app_config['site']),
                      account.vp_cross_reference)
    
        if !payment_result.success?
          flash[:cc_error] = payment_result.message
          return false
        end

         account.validate_cc = false
        account.vp_cross_reference = cc_transaction.vp_cross_reference
        account.currency = cc_transaction.currency

      else
        # should never get here, because the view wouldn't present the choice of using current cc
        begin
          raise RuntimeError, "Couldn't find a cross reference"
          rescue RuntimeError => e
            logger.error("MAJOR BALLS UP")
            ExceptionNotifier.deliver_exception_notification(e, self, request)
            flash[:error] = "A credit card cross reference token is missing. Your credit card was not charged, but still - this should never have happened. An email has been sent to us to rectify the problem. Please send us an email as well so that we can sort it out ASAP. Really sorry about this."
        end
        return false
      end
      
      if account.save
        audit_paid_change_plan(account, current_user, cc_transaction.amount, cc_transaction.order_number)
        send_invoice(account, cc_transaction.order_number)
        return true
      else
        begin
          raise RuntimeError, "Couldn't upgrade/downgrade account"
          rescue RuntimeError => e
            logger.error("MAJOR BALLS UP")
            ExceptionNotifier.deliver_exception_notification(e, self, request, { :account => account })
            flash[:error] = "Your credit card was charged, but there was a problem upgrading/downgrading your account. An email has been sent to us to rectify the problem. Please send us an email as well so that we can sort it out ASAP. Really sorry about this."
        end
        return false
      end
    end
  end  
end
