require 'payment_gateway'

class SignupController < ApplicationController
  session :off
  # before_filter :require_ssl, :except => [:index, :plans]

  # shows plans
  def index
    @plans = find_plans
  end
  
  def free
    get_lookups

    if request.get?
      create_new_objects
      @account.plan = Plan.find(Plan::FREE)
      return
    end
    get_objects_from_params
    @preference = Preference.new
    set_preference_defaults
    @account.plan = Plan.find(Plan::FREE)
    @account.validate_cc = false
    return if errors?(@account, @preference, @user)
    
    if save(@account, @preference, @user)
      audit_free_signup(@account, @user)
      send_welcome_free_email(@account)
      redirect_to "http://#{base_url(@account)}/login/jump_from_signup?id=#{@user.id}&key=#{@user.generate_security_token(15)}"
    end
  end

  def lite
    signup(Plan::LITE)
  end

  def hardcore
    signup(Plan::HARDCORE)
  end

  def ultimate
    signup(Plan::ULTIMATE)
  end

private

  def create_new_objects
    @user = User.new
    @account = Account.new
  end

  def set_preference_defaults
    @preference.currency_id = @app_config["default_currency"]
    @preference.tax_system = @app_config["default_tax_system"]
    @preference.timezone = @app_config["default_timezone"]
    @preference.thankyou_message = ""
    @preference.reminder_message = ""
    @preference.invoice_notes = ""
  end

  def get_objects_from_params
    @user = User.new(params[:user])
    @account = Account.new(params[:account])
  end

  def get_lookups
    @currencies = Currency.find(:all, :order => 'name')
    @taxes = Tax.find(:all)
  end

  def signup(plan_id)
    if ENV['RAILS_ENV'] == 'production'
      flash[:notice] = "The paid plans are not yet available ... still busy hooking it all up to a bank. So, if you did sign up - your credit card details were ignored. "
      redirect_to :action => "free"
      return
    end
    get_lookups

    if request.get?
      create_new_objects
      @account.plan = Plan.find(plan_id)
      return
    end
    get_objects_from_params
    @preference = Preference.new
    set_preference_defaults
    @account.plan = Plan.find(plan_id)
    @account.validate_cc = true
    return if errors?(@account, @preference, @user)

    @creditcard = PaymentGateway::creditcard(@account)
    return if !@creditcard.valid?
    
    payment_result, cc_transaction = PaymentGateway.take_recurring_payment(
                  @account,
                  @app_config['currency_to_bill'],
                  @account.plan.cost(@app_config['site']),
                  @creditcard)

    if !payment_result.success?
      flash[:cc_error] = payment_result.message
      return
    end

    @account.vp_cross_reference = cc_transaction.vp_cross_reference
    @account.cc_last_4_digits = cc_transaction.cc_last_4_digits
    @account.currency = cc_transaction.currency
    
    if save(@account, @preference, @user, cc_transaction)
      audit_paid_signup(@account, @user, cc_transaction.amount, cc_transaction.order_number)
      send_welcome_paid_email(@account)
      send_invoice(@account, cc_transaction.order_number)
      redirect_to "http://#{base_url(@account)}/login/jump_from_signup?id=#{@user.id}&key=#{@user.generate_security_token(15)}"
    else
      # should never happen??
      begin
        raise RuntimeError, "Couldn't create account on signup"
        rescue RuntimeError => e
          logger.error("MAJOR BALLS UP")
          ExceptionNotifier.deliver_exception_notification(e, self, request)
          flash[:error] = "Your credit card was charged, but there was a problem setting up your new account. An email has been sent to us to rectify the problem. Please send us an email as well so that we can sort it out ASAP. Really sorry about this."
      end
    end
  end
  
  def errors?(account, preference, user)
    account.valid?
    user.valid?
    preference.valid?
    !account.errors.empty? || !user.errors.empty? || !preference.errors.empty?
  end

  def save(account, preference, user, cc_transaction = nil)
    begin
      Account.transaction do
        User.transaction do
          Preference.transaction do
            if preference.save
              account.preference = preference
              if account.save
                user.account_id = account.id
                cc_transaction.update_attribute(:account_id, account.id) if cc_transaction 
                if user.save
                  account.update_attribute(:primary_person_id, user.id)
                  return true
                end
              end
            end
          end
        end
      end
    rescue
      flash[:error] = "Error creating account: Please try again in a few minutes."
      logger.error("Error creating account")
      logger.error($!)
      ExceptionNotifier.deliver_exception_notification($!, self, request)
      return false
    end
  end

  def audit_free_signup(account, user)
    begin
      AuditSignup.record_free(account.subdomain, user.email, @app_config['site'], request.remote_ip)
    rescue
      logger.error("Error auditing free signup")
      logger.error($!)
      ExceptionNotifier.deliver_exception_notification($!, self, request)
    end
  end

  def audit_paid_signup(account, user, amount, order_number)
    begin
      AuditSignup.record_paid(account.subdomain, user.email, @app_config['site'], request.remote_ip, account.plan.name,
                              account.cc_name, account.cc_address1, account.cc_address2, account.cc_city, account.cc_postalcode, account.cc_country,
                              account.cc_type, account.cc_last_4_digits, account.cc_expiry, account.currency, amount, order_number)
    rescue
      logger.error("Error auditing paid signup")
      logger.error($!)
      ExceptionNotifier.deliver_exception_notification($!, self, request)
    end
  end

  def send_welcome_free_email(account)
    begin
      SystemMailer.deliver_welcome_free(:from => "#{@app_config['system_email']}", :account => account, :base_url => base_url(@account))
    rescue
      logger.error("Error sending welcome free email")
      logger.error($!)
      ExceptionNotifier.deliver_exception_notification($!, self, request)
    end
  end    

  def send_welcome_paid_email(account)
    begin
      SystemMailer.deliver_welcome_paid(:from => "#{@app_config['system_email']}", :account => account, :base_url => base_url(@account))
    rescue
      logger.error("Error sending welcome paid email")
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

end
