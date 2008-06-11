class InvoicesController < ApplicationController
  before_filter :login_required
  before_filter :invoice_limit_reached?, :only => [:create, :new]
  after_filter :store_location, :except => [:create, :new, :edit, :delete, :get_currency_symbol]

  def index
    if params[:states]
      @invoices = []
      states = prepare_states
      states.each do |state|
        case state
          when "all":
            @all = true
            @invoices = @account.invoices
          when "open": 
            @open = true
            @invoices += @account.open_invoices
          when "overdue":
            @overdue = true
            @invoices += @account.overdue_invoices
          when "closed":
            @closed = true
            @invoices += @account.closed_invoices
        end
      end
      @all = !@open && !@overdue && !@closed
      @invoices.sort {|x,y| y.date <=> x.date }
    else
      @all = true
      @invoices = @account.invoices
    end
    
    @blog_headline = BlogHeadline.get
    @home_url = "http://www.#{@app_config['domain']}"
    
    render_different_formats
  end

  def show
    @invoice = our_invoice(params[:id])
    return if @invoice.nil?
    @payment = Payment.new

    if @invoice.closed?
      @thankyou_message = thankyou_message(@invoice)
    end

    if @invoice.past_due?
      @reminder_message = reminder_message(@invoice)
    end

    render_different_formats
  end

  def create
    if request.get?
      session[:client_id] = nil
      session[:invoice_client_name] = nil
    else
      if !params[:newclient].blank? && params[:newclient] != "Enter a new client" 
        session[:original_return_to] = session[:return_to]
        store_location url_for(:action => 'new')
        session[:invoice_client_name] = params[:newclient]
        redirect_to :controller => 'clients', :action => 'new'
        return
      elsif !params[:client].blank? && params[:client].to_i > 0
        session[:client_id] = params[:client]
        redirect_to :action => 'new'
      else
        flash[:notice] = "You need to either pick a client from the dropdown (if you have any clients), or type in the name of a new client."
      end
    end
  end

  def new
    if request.get?
      # might arrive here from cancelling a "new client"
      session[:return_to] = session[:original_return_to] || session[:return_to]
      session[:original_return_to] = nil

      session[:client_id] ||= session[:new_client_id]
      return if !session_variables_present?


      client = our_client(session[:client_id])
      return if client.nil?

      # set client_id as well, as we need it for the view
      @invoice = Invoice.new({   :account_id => @account.id,
                                :client_id => session[:client_id] })

      @invoice.setup_defaults

      # and set up an invoice lines collection with one invoice line, to prep the form with
      # @invoice.invoice_lines = []
      @invoice.invoice_lines << InvoiceLine.new({ :invoice_line_type_id => 1, :quantity => 1, :price => 0.00, :description => "" })

    else

      return if !session_variables_present?

      # set all parameters and extra stuff we didn't get from the form
      @invoice = Invoice.new(params[:invoice].merge(audit_create_trail))
      @invoice.attributes = { :account_id => @account.id,
                              :client_id => session[:client_id],
                              :tax_system =>   @account.preference.tax_system,
                              :status_id => Status.get_new_status_id(@account) }

      return if save_invoice(@invoice, extract_lines_from_params)

    end

    get_lookups
  end

  def edit
     @invoice = our_invoice(params[:id])
     return if @invoice.nil?

     get_lookups

    if request.get?
      return
    end

    @invoice.attributes = params[:invoice].merge(audit_update_trail)
    save_invoice(@invoice, extract_lines_from_params)
  end

  def make_live
    if !@account.plan.free?
       @invoice = our_invoice(params[:id])
       return if @invoice.nil?
      @invoice.update_attribute(:status_id, Status::OPEN)
    end
    redirect_to :action => "show", :id => params[:id] 
  end

  def make_draft
    if !@account.plan.free?
       @invoice = our_invoice(params[:id])
       return if @invoice.nil?
      @invoice.update_attribute(:status_id, Status::DRAFT)
    end
     redirect_to :action => "show", :id => params[:id] 
  end

  def get_currency_symbol
    currency = Currency.find(params[:currency])
    render :text => currency.nil? ? '' : currency.symbol, :layout => false
  end

  def deliver_invoice
    @invoice = our_invoice(params[:id])
    return if @invoice.nil?

    to = extract_recipients_from_params(params[:invoiceto])
    return if to.nil?

    from = format_from
    summary_url = get_summary_url(@invoice.id)

    invoice_html = construct_html_for_invoice(@invoice)
  
    email = InvoiceMailer.create_invoice(to, from, "", @account, @invoice, invoice_html, summary_url, params[:message], @app_config)

    deliver("Invoice", email, @invoice)

    @invoice.update_attribute(:status_id, Status::OPEN) if @invoice.draft?

    redirect_back_or_default
  end

  def deliver_reminder
    @invoice = our_invoice(params[:id])
    return if @invoice.nil?

    to = extract_recipients_from_params(params[:reminderto])
    return if to.nil?

    from = format_from
    summary_url = get_summary_url(@invoice.id)

    invoice_html = construct_html_for_invoice(@invoice)

    email = InvoiceMailer.create_reminder(to, from, "", @account, @invoice, invoice_html, summary_url, params[:reminder_message], @app_config)
    deliver("Reminder", email, @invoice)
    redirect_back_or_default
  end

  def deliver_thankyou
     @invoice = our_invoice(params[:id])
     return if @invoice.nil?

    to = extract_recipients_from_params(params[:thankyouto])
    return if to.nil?

     from = format_from
    summary_url = get_summary_url(@invoice.id)

    email = InvoiceMailer.create_thankyou(to, from, "", @account, @invoice, summary_url, params[:thankyou_message], @app_config)
    deliver("Thankyou", email, @invoice)
     redirect_back_or_default
  end

  def delete
    invoice = our_invoice(params[:id])
    return if invoice.nil?

    invoice.destroy
    redirect_to :action => '' # always go back to summary view
  end

private

  def invoice_line_messages(errors)
    messages = []

    errors.each do |attr, val|
      errors[attr].each do |msg|
        next if msg.nil?
        messages << msg
      end
    end

    return messages
  end

  def get_lookups
    @currencies = Currency.find(:all, :order => 'name')
    @terms = Term.find(:all, :order => 'days')
    @invoice_line_types = InvoiceLineType.find(:all, :order => 'position')
    @last_invoice_number_used = Invoice.last_number_used(@account.id)
  end

  def extract_lines_from_params
    invoice_lines = Array.new
    if !params[:line_items].nil?
      params[:line_items].each do |line_no, attr|
        invoice_line = InvoiceLine.new(attr.merge(audit_create_trail))
        invoice_line.account_id = @account.id
        invoice_lines << invoice_line
      end
    end
    return invoice_lines
  end

  def session_variables_present?
    if session[:client_id].nil?
      flash[:notice] = "Please select a client for your new invoice"
      redirect_to :action => 'create'
      return false
    end
    return true
  end

  def save_invoice(invoice, invoice_lines)
    # need this check here, else we clear the invoice lines, never to see them again.
    if invoice_lines.size == 0
      invoice.errors.add(:invoice_lines, "not there. You need at least one invoice line")
      return false
    end
    begin
      InvoiceLine.transaction do
        Invoice.transaction do
          invoice.invoice_lines.clear
          invoice.invoice_lines = invoice_lines
          invoice.invoice_lines.each do |invoice_line|
            if !invoice_line.valid?
              invoice.errors.add(:invoice_lines, invoice_line_messages(invoice_line.errors).join(", "))
              return false
            end
          end
          if invoice.save
            flash[:notice] = "Your invoice has been saved. You can send it by clicking 'Send Invoice'"
            redirect_to :action => 'show', :id => invoice.id
            session[:client_id] = nil
            return true
          end
        end
      end
      return false
    rescue
      flash[:error] = "Error saving invoice: Please try again in a few minutes."
      logger.error("Error saving invoice")
      logger.error($!)
      return false
    end
  end

  def log_email(email_type, invoice, to, amount_due=nil)
    begin
      email_log = EmailLog.new({ :account_id => invoice.account_id, :invoice_id => invoice.id, :client_id => invoice.client_id })
      email_log.email_type = email_type
      email_log.to = to
      email_log.from = "#{current_user.firstname} #{current_user.lastname} <#{current_user.email}>"
      email_log.amount_due = amount_due
      email_log.sent_on = Time.now # TODO: handle with TimeZones
      email_log.attributes = audit_create_trail
      email_log.save
    rescue
      logger.error("Error logging email")
      logger.error($!)
    end
  end

  def extract_recipients_from_params(recipients=nil)
     to = []
     if !recipients.nil?
      recipients.each do |id, attr|
        if attr[:send] == "1"
          contact = our_person(id)
          if contact.nil?
            flash[:error] = "Illegal contact. Your email was not sent"
            logger.error("Trying to send to illegal contact")
            logger.error($!)
            redirect_back_or_default
            return nil
          end
          to << contact.email
        end
      end
    end

    if to.size == 0
      flash[:notice] = "You need to pick at least one contact. Your email was not sent"
      redirect_back_or_default
      return nil
    end

    return to
  end

  def format_from
    "#{current_user.firstname} #{current_user.lastname} <#{current_user.email}>"
  end

  def get_summary_url(invoice_id)
    "http://#{base_url}/summary/" + "show".obfuscate + "/" + invoice_id.to_s.obfuscate
  end

  def deliver(email_type, email, invoice)
     if InvoiceMailer.deliver(email)
       log_email(email_type, invoice, email.to.join(", "), invoice.amount_due)
       flash[:notice] = "Your email was sent successfully"
     else
       flash[:error] = "There was a problem sending your email. We have logged this error and will try and figure out what's going on."
      logger.error("Error sending invoice")
      logger.error($!)
     end
  end

  def reminder_message(invoice)
    if @account.preference.reminder_message.blank?
      msg = "Dear #{invoice.client.name}\n\n"
      msg += "The balance on invoice ##{invoice.number} is #{distance_of_time_in_words(Date.today, invoice.due_date)} overdue.\n\n"
      msg += "If you have already sent the remaining balance, please ignore this reminder. If not, please see to it as soon as possible to organize payment.\n\n"
      msg += "If you have any queries regarding this invoice, please get in contact with us immediately. You can send an email to #{current_user.email}. Thank you."
    else
      @account.preference.reminder_message
    end
  end

  def thankyou_message(invoice)
    if @account.preference.thankyou_message.blank?
      "Dear #{invoice.client.name}\n\nThank you! we have received your payment."
    else
      @account.preference.thankyou_message
    end
  end

  # sucked it out of ActionView helper methods
  def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round

    case distance_in_minutes
      when 0..1
        return (distance_in_minutes==0) ? 'less than a minute' : '1 minute' unless include_seconds
        case distance_in_seconds
          when 0..5   then 'less than 5 seconds'
          when 6..10  then 'less than 10 seconds'
          when 11..20 then 'less than 20 seconds'
          when 21..40 then 'half a minute'
          when 41..59 then 'less than a minute'
          else             '1 minute'
        end

      when 2..45      then "#{distance_in_minutes} minutes"
      when 46..90     then 'about 1 hour'
      when 90..1440   then "about #{(distance_in_minutes.to_f / 60.0).round} hours"
      when 1441..2880 then '1 day'
      else                 "#{(distance_in_minutes / 1440).round} days"
    end
  end

  def prepare_states
    states = params[:states].downcase.split(',').uniq
    states = ["all"] if states.include?("all")
    states
  end

  def apply_excel_header
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = "attachment;filename=#{generate_excel_filename}"
  end     

  def generate_excel_filename
    s = "#{@app_config['app_name']}.xls"
  end
  
  def render_different_formats
    case params[:format]
      when "xml":
        render :template => "invoices/export/#{action_name}.rxml", :layout => false
        return true
      when "xls":
        apply_excel_header
        render :template => "invoices/export/#{action_name}.rxls", :layout => false
        return true
    end
  end

  def construct_html_for_invoice(invoice)
    td_style = %Q(style="font-size: 12px; padding: 5px; border-bottom: 1px solid #E4E4D2;")
    th_style = %Q(style="font-size: 12px; padding: 5px;")
    s = render_to_string(:partial => 'show_invoice', :locals => { :invoice => @invoice })
    s.gsub!(/class="type"/, %Q(width="75" align="left" valign="top"))
    s.gsub!(/class="quantity"/, %Q(width="45" align="left" valign="top"))
    s.gsub!(/class="description"/, %Q(width="255" align="left" valign="top"))
    s.gsub!(/class="price"/, %Q(width="85" align="left" valign="top"))
    s.gsub!(/class="total"/, %Q(width="120" align="right" valign="top"))
    s.gsub!(/class="calcs"/, %Q(width="250" align="right" valign="top"))
    s.gsub!(/class="terms"/, %Q(valign="bottom" width="365" border="0" align="left"))
    s.gsub!(/class="c1"/, %Q(nowrap align="left" valign="top"))
    s.gsub!(/class="c2"/, %Q(nowrap align="right" valign="top"))
    s.gsub!(/<td /, "<td #{td_style} ")
    s.gsub!(/<th /, "<th #{th_style} ")
    s
  end
  
end
