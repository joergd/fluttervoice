# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
require 'user_system'
require 'plan_system'
require 'ruby_extensions'

class ApplicationController < ActionController::Base

  before_filter :configure_charsets
  
  include ExceptionNotifiable
  
  # user functionality
  include UserSystem
  include PlanSystem

  # subdomain functionality
  attr_writer :account
  attr_reader :account

  before_filter :set_session_expiration
  before_filter :create_country_domain_specific_app_config
  before_filter :extract_account_from_url
  before_filter :display_msg_if_non_existent_account

  before_filter :set_timezone
  before_filter :redirect_if_wrong_user_for_account

private

  def set_timezone
    Time.zone = @account.preference.nil? ? 'Pretoria' : @account.preference.timezone
  end
  
  def local_request?
    ENV['RAILS_ENV'] == "development"
  end
  
  def require_ssl
      redirect_to :protocol => "https://" unless (request.ssl? || local_request?)  
  end
  
  def current_user
    session[:user]
  end
  
  def handle_error(publicMsg, devMsg, url = url_for(:controller => 'problem', :action => ''))
    logger.error(devMsg)
    flash[:notice] = publicMsg if publicMsg
    redirect_to url
  end

  def base_url(account = @account)
    "#{account.subdomain.downcase}.#{@app_config["domain"]}"
  end

  def find_plans
    Plan.find(:all, :conditions => [ "special = 0" ], :order => "seq DESC")
  end

  def set_session_expiration
    # If no session we don't care
    if @session
      # Get expiry time (allow ten seconds window for the case where we have none)
      expiry_time = session[:expiry_time] || Time.now + 10
      if expiry_time < Time.now
        # Too late, matey...  bang goes your session!
        reset_session
      else
        # Okay, you get another hour
        session[:expiry_time] = Time.now + (60*60)
      end
    end
  end

  def create_country_domain_specific_app_config
    @app_config = APP_COUNTRIES_CONFIG[country_domain]
  end

  def extract_account_from_url
    @account = Account.find_by_subdomain(request.subdomains(@app_config["tld_length"]).first || 'www', :include => [ :preference, :plan ]) rescue Account.find_by_subdomain("www")
  end

  def country_domain
    request.host.split('.').last
  end

  def configure_charsets
    # make sure the charset in the HTML header is set to utf-8 as well
    suppress(ActiveRecord::StatementInvalid) do
      ActiveRecord::Base.connection.execute 'SET NAMES UTF8'
    end
  end

  def display_msg_if_non_existent_account
    if @account.nil?
      render :template => "available"
      return false
    end
  end

  def redirect_if_wrong_user_for_account
    if !@account.nil? && @account.id > 1 && !["login", "change_plan", "admin"].include?(controller_name)
      if !current_user.nil? && current_user.account_id != @account.id
        flash[:notice] = "You are logged-in with a username that is not valid for this account. Please try a different username instead."
        redirect_to "http://#{@account.subdomain}.#{@app_config["domain"]}/login"
        return false
      end
    end
  end

  def our_payment(payment_id)
     payment = Payment.find_by_id_and_account_id(payment_id, @account.id)

    # make sure we exit gracefully if an illegal id gets passed in
     if payment.nil?
      logger.error("Attempt to access invalid payment #{payment_id}")
      flash[:error] = 'Invalid payment'
      redirect_back_or_default url_for(:action => 'index')
      return nil
    end
    return payment
  end

  def our_invoice(invoice_id)
     invoice = Invoice.find_by_id_and_account_id(invoice_id, @account.id)

    # make sure we exit gracefully if an illegal id gets passed in
     if invoice.nil?
      logger.error("Attempt to access invalid invoice #{invoice_id}")
      flash[:error] = 'Invalid invoice'
      redirect_back_or_default url_for(:action => 'index')
      return nil
    end
    return invoice
  end

  def our_client(client_id)
     client = Client.find_by_id_and_account_id(client_id, @account.id)

    # make sure we exit gracefully if an illegal id gets passed in
     if client.nil?
      logger.error("Attempt to access invalid client #{client_id}")
      flash[:error] = 'Invalid client'
      redirect_back_or_default url_for(:action => 'index')
      return nil
    end
    return client
  end

  def our_person(person_id)
     person = Person.find_by_id_and_account_id(person_id, @account.id)

    # make sure we exit gracefully if an illegal id gets passed in
     if person.nil?
      logger.error("Attempt to access invalid person #{person_id}")
      flash[:error] = 'Invalid person'
      redirect_back_or_default url_for(:action => 'index')
      return nil
    end
    return person
  end

  def main_site?
    ['www'].include?(@account.subdomain)
  end

  def audit_create_trail
    { :audit_created_by_person_id => current_user[:id] }
  end

  def audit_update_trail
    { :audit_updated_by_person_id => current_user[:id] }
  end

end
