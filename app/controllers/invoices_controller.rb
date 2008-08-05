class InvoicesController < DocumentsController
  before_filter :login_required, :except => [:email_demo_invoice]
  before_filter :invoice_limit_reached?, :only => [:create, :new, :new_from_quote]
  after_filter :store_location, :except => [:create, :new, :edit, :delete, :email_demo_invoice]

  def index
    if params[:states]
      @documents = []
      states = prepare_states
      states.each do |state|
        case state
          when "all":
            @all = true
            @documents = @account.invoices
          when "open": 
            @open = true
            @documents += @account.open_invoices
          when "overdue":
            @overdue = true
            @documents += @account.overdue_invoices
          when "closed":
            @closed = true
            @documents += @account.closed_invoices
        end
      end
      @all = !@open && !@overdue && !@closed
      @documents.sort {|x,y| y.date <=> x.date }
    else
      @all = true
      @documents = @account.invoices
    end

    @blog_headline = BlogHeadline.get
    @home_url = "http://www.#{@app_config['domain']}"

    render_different_formats
  end

  def show
    @document = our_document(params[:id])
    return if @document.nil?
    @payment = Payment.new

    if @document.closed?
      @thankyou_message = thankyou_message(@document)
    end

    if @document.past_due?
      @reminder_message = reminder_message(@document)
    end

    render_different_formats
  end

  def create
    if request.get?
      session[:client_id] = nil
      session[:document_client_name] = nil
    else
      if !params[:newclient].blank? && params[:newclient] != "Enter a new client" 
        session[:original_return_to] = session[:return_to]
        store_location url_for(:action => 'new')
        session[:document_client_name] = params[:newclient]
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
      @document = Invoice.new({   :account_id => @account.id,
                                :client_id => session[:client_id] })

      @document.setup_defaults

      # and set up an invoice lines collection with one invoice line, to prep the form with
      # @document.line_items = []
      @document.line_items << LineItem.new({ :line_item_type_id => 1, :quantity => 1, :price => 0.00, :description => "" })

    else

      return if !session_variables_present?

      # set all parameters and extra stuff we didn't get from the form
      @document = Invoice.new(params[:document].merge(audit_create_trail))
      @document.attributes = { :account_id => @account.id,
                              :client_id => session[:client_id],
                              :tax_system =>   @account.preference.tax_system,
                              :status_id => Status.get_new_status_id(@account) }

      return if save_document(@document, extract_lines_from_params)

    end

    get_lookups
  end

  def new_from_quote
    quote = our_document(params[:quote_id])
    return if quote.nil?
    
    @document = Invoice.new(quote.attributes)
    @document.number = nil
    @document.date = nil
    
    quote.line_items.each do |line_item|
      @document.line_items << LineItem.new(line_item.attributes)
    end

    session[:client_id] = quote.client_id
    
    get_lookups
    
    render :action => "new"
  end
  
  def edit
     @document = our_document(params[:id])
     return if @document.nil?

     get_lookups

    if request.get?
      return
    end

    @document.attributes = params[:document].merge(audit_update_trail)
    save_document(@document, extract_lines_from_params)
  end

  def make_live
    if !@account.plan.free?
       @document = our_document(params[:id])
       return if @document.nil?
      @document.update_attribute(:status_id, Status::OPEN)
    end
    redirect_to :action => "show", :id => params[:id] 
  end

  def make_draft
    if !@account.plan.free?
       @document = our_document(params[:id])
       return if @document.nil?
      @document.update_attribute(:status_id, Status::DRAFT)
    end
     redirect_to :action => "show", :id => params[:id] 
  end

  def deliver_invoice
    @document = our_document(params[:id])
    return if @document.nil?

    to = extract_recipients_from_params(params[:invoiceto])
    return if to.nil?

    from = format_from
    summary_url = get_summary_url(@document.id)

    invoice_html = construct_email_html_for_document(@document)

    email = DocumentMailer.create_invoice(to, from, "", @account, @document, invoice_html, summary_url, params[:message], @app_config)

    deliver("Invoice", email, @document)

    @document.update_attribute(:status_id, Status::OPEN) if @document.draft?

    redirect_back_or_default
  end

  def deliver_reminder
    @document = our_document(params[:id])
    return if @document.nil?

    to = extract_recipients_from_params(params[:reminderto])
    return if to.nil?

    from = format_from
    summary_url = get_summary_url(@document.id)

    invoice_html = construct_email_html_for_document(@document)

    email = DocumentMailer.create_reminder(to, from, "", @account, @document, invoice_html, summary_url, params[:reminder_message], @app_config)
    deliver("Reminder", email, @document)
    redirect_back_or_default
  end

  def deliver_thankyou
     @document = our_document(params[:id])
     return if @document.nil?

    to = extract_recipients_from_params(params[:thankyouto])
    return if to.nil?

     from = format_from
    summary_url = get_summary_url(@document.id)

    email = DocumentMailer.create_thankyou(to, from, "", @account, @document, summary_url, params[:thankyou_message], @app_config)
    deliver("Thankyou", email, @document)
     redirect_back_or_default
  end

  def delete
    invoice = our_document(params[:id])
    return if invoice.nil?

    invoice.destroy
    redirect_to :action => '' # always go back to summary view
  end

  # Used from the Homepage
  def email_demo_invoice
    if params[:email] =~ /^([a-zA-Z0-9_\-\.&]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/
      @document = Invoice.demo # HARDCODED: A Demo Invoice
      return if @document.nil?

      account = Account.demo
      to = params[:email]
      from = @app_config['system_email']
      message = "This is a demo invoice that somebody sent from http://www.fluttervoice.co.za. Please let us know of any abuse."
      summary_url = "http://#{base_url(account)}/summary/" + "show".obfuscate + "/" + @document.id.to_s.obfuscate

      invoice_html = construct_email_html_for_document(@document)

      if DocumentMailer.deliver_invoice(to, from, "", account, @document, invoice_html, summary_url, message, @app_config)
        log_email("Demo", @document, to, 0)
        render :text => "", :status => 200
      else
        render :text => "Can't send.", :status => 200
      end
    else
      render :text => "Malformed email", :status => 200
    end
  end

private

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

  def get_last_document_number_used
    Invoice.last_number_used(@account.id)
  end
  

end
