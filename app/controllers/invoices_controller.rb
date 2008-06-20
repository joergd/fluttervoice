class InvoicesController < DocumentsController
  before_filter :invoice_limit_reached?, :only => [:create, :new]
  after_filter :store_location, :except => [:create, :new, :edit, :delete]

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
      # @invoice.line_items = []
      @invoice.line_items << LineItem.new({ :line_item_type_id => 1, :quantity => 1, :price => 0.00, :description => "" })

    else

      return if !session_variables_present?

      # set all parameters and extra stuff we didn't get from the form
      @invoice = Invoice.new(params[:invoice].merge(audit_create_trail))
      @invoice.attributes = { :account_id => @account.id,
                              :client_id => session[:client_id],
                              :tax_system =>   @account.preference.tax_system,
                              :status_id => Status.get_new_status_id(@account) }

      return if save_document(@invoice, extract_lines_from_params)

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
    save_document(@invoice, extract_lines_from_params)
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

  def deliver_invoice
    @invoice = our_invoice(params[:id])
    return if @invoice.nil?

    to = extract_recipients_from_params(params[:invoiceto])
    return if to.nil?

    from = format_from
    summary_url = get_summary_url(@invoice.id)

    invoice_html = construct_email_html_for_document(@invoice)

    email = DocumentMailer.create_invoice(to, from, "", @account, @invoice, invoice_html, summary_url, params[:message], @app_config)

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

    invoice_html = construct_email_html_for_document(@invoice)

    email = DocumentMailer.create_reminder(to, from, "", @account, @invoice, invoice_html, summary_url, params[:reminder_message], @app_config)
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

    email = DocumentMailer.create_thankyou(to, from, "", @account, @invoice, summary_url, params[:thankyou_message], @app_config)
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


end
