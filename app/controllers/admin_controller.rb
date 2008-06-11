class AdminController < ApplicationController
  before_filter :admin_required

  def index
  end
  
  def collect_subscriptions
    @accounts = Account.find(:all, :conditions => "deleted = 0 and plan_id > 1")
  end

  def collect
    if request.post?

      @acc = Account.find(params[:id])
      if do_collect(@acc)
        redirect_to :action => "collect_subscriptions"
      else
        @accounts = Account.find(:all, :conditions => "deleted = 0 and plan_id > 1")
        render :action => "collect_subscriptions"
      end
    end
  end
  
private

  def audit_repeat_payment(account, user, amount, order_number)
    begin
      AuditRepeatPayment.record_paid(account.subdomain, user.email, @app_config['site'], request.remote_ip, account.plan.name,
                              account.cc_name, account.cc_address1, account.cc_address2, account.cc_city, account.cc_postalcode, account.cc_country,
                              account.cc_type, account.cc_last_4_digits, account.cc_expiry, account.currency, amount, order_number)
    rescue
      logger.error("Error auditing paid repeat payment")
      logger.error($!)
      ExceptionNotifier.deliver_exception_notification($!, self, request)
    end
  end

  def do_collect(account)
    if !account.vp_cross_reference.blank?
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
      audit_repeat_payment(account, current_user, cc_transaction.amount, cc_transaction.order_number)
      return true
    else
      begin
        raise RuntimeError, "Couldn't save new account information. CC was charged."
        rescue RuntimeError => e
          logger.error("MAJOR BALLS UP")
          ExceptionNotifier.deliver_exception_notification(e, self, request, { :account => account })
          flash[:error] = "Couldn't save new account information. CC was charged. #{e}"
      end
      return false
    end
  end
  
end
