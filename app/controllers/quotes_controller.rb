class QuotesController < DocumentsController
  before_filter :login_required
  before_filter :quote_limit_reached?
  before_filter :can_have_quotes?, :only => [:index, :create, :new, :edit]
  after_filter :store_location, :except => [:create, :new, :edit, :delete]

  def index
    if params[:states]
      @documents = []
      states = prepare_states
      states.each do |state|
        case state
          when "all":
            @all = true
            @documents = @account.quotes
          when "open": 
            @open = true
            @documents += @account.open_quotes
          when "expired":
            @expired = true
            @documents += @account.expired_quotes
        end
      end
      @all = !@open && !@expired
      @documents.sort {|x,y| y.date <=> x.date }
    else
      @all = true
      @documents = @account.quotes
    end

    render_different_formats
  end

  def show
    @document = our_document(params[:id])
    return if @document.nil?

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
      @document = Quote.new({   :account_id => @account.id,
                                :client_id => session[:client_id] })

      @document.setup_defaults

      # and set up an quote lines collection with one quote line, to prep the form with
      # @document.line_items = []
      @document.line_items << LineItem.new({ :line_item_type_id => 1, :quantity => 1, :price => 0.00, :description => "" })

    else

      return if !session_variables_present?

      # set all parameters and extra stuff we didn't get from the form
      @document = Quote.new(params[:document].merge(audit_create_trail))
      @document.attributes = { :account_id => @account.id,
                              :client_id => session[:client_id],
                              :tax_system =>   @account.preference.tax_system,
                              :status_id => Status.get_new_status_id(@account) }

      return if save_document(@document, extract_lines_from_params)

    end

    get_lookups
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

  def deliver_quote
    @document = our_document(params[:id])
    return if @document.nil?

    to = extract_recipients_from_params(params[:quoteto])
    return if to.nil?

    from = format_from
    summary_url = get_summary_url(@document.id)

    quote_html = construct_email_html_for_document(@document)

    email = DocumentMailer.create_quote(to, from, "", @account, @document, quote_html, summary_url, params[:message], @app_config)

    deliver("quote", email, @document)

    @document.update_attribute(:status_id, Status::OPEN) if @document.draft?

    redirect_back_or_default
  end

  def delete
    quote = our_document(params[:id])
    return if quote.nil?

    quote.destroy
    redirect_to :action => '' # always go back to summary view
  end

private

  def get_last_document_number_used
    Quote.last_number_used(@account.id)
  end
  

end
