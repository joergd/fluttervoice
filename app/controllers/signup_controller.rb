class SignupController < ApplicationController

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
    return if errors?(@account, @preference, @user)
    
    if save(@account, @preference, @user)
      audit_free_signup(@account, @user)
      send_welcome_free_email(@account)
      redirect_to "http://#{base_url(@account)}/sessions/jump_from_signup?id=#{@user.id}&key=#{@user.generate_jump_token(15)}"
    end
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
    @preference.document_template_id = DocumentTemplate::DEFAULT
  end

  def get_objects_from_params
    @user = User.new(params[:user])
    @account = Account.new(params[:account])
  end

  def get_lookups
    @currencies = Currency.find(:all, :order => 'name')
    @taxes = Tax.find(:all)
  end

  
  def errors?(account, preference, user)
    account.valid?
    user.valid?
    preference.valid?
    !account.errors.empty? || !user.errors.empty? || !preference.errors.empty?
  end

  def save(account, preference, user)
    begin
      Account.transaction do
        User.transaction do
          Preference.transaction do
            if preference.save
              account.preference = preference
              if account.save
                user.account_id = account.id
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
      ExceptionNotifier.deliver_exception_notification($!, self, request)
      return false
    end
  end

  def audit_free_signup(account, user)
    begin
      AuditSignup.record_free(account.subdomain, user.email, @app_config['site'], request.remote_ip)
    rescue
      logger.error("Error auditing free signup")
      ExceptionNotifier.deliver_exception_notification($!, self, request)
    end
  end

  def send_welcome_free_email(account)
    begin
      SystemMailer.deliver_welcome_free(:from => "#{@app_config['system_email']}", :account => account, :base_url => base_url(@account))
    rescue
      logger.error("Error sending welcome free email")
      ExceptionNotifier.deliver_exception_notification($!, self, request)
    end
  end    

end
