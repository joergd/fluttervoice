class ClientsController < ApplicationController
  before_filter :login_required
  before_filter :client_limit_reached?, :only => [:new]
  after_filter :store_location, :except => [:edit, :new]

  def index
    render_different_formats
  end

  def show
     @client = our_client(params[:id])
     return if @client.nil?
    render_different_formats
  end
  
  def new
    if request.get?
      session[:new_client_id] = nil
      @client = Client.new()
      populate_name_from_create_invoice
      @contact = Contact.new
      return
    end

    @client = Client.new(params[:client].merge(audit_create_trail))
    @contact = Contact.new(params[:contact].merge(audit_create_trail))

    @client.valid?
    @contact.valid?

    if !@client.errors.empty? || !@contact.errors.empty?
      return
    end

    begin
      Client.transaction do
        Contact.transaction do
          @account.clients << @client
          if @client.save
            @contact.account_id = @account.id # make link to account explicit
            @client.contacts << @contact
            if @contact.save
              flash[:notice] = "A new client has been created!"
              session[:new_client_id] = @client.id
              redirect_back_or_default
              return
            end
          end
        end
      end
    rescue
      flash[:error] = "Error creating client: Please try again in a few minutes."
      logger.error("Error creating client")
    end
  end

  def edit
     @client = our_client(params[:id])
     return if @client.nil?

    # we haven't changed any info yet, so just show the form
    if request.get?
      return
    end

    if @client.update_attributes(params[:client].merge(audit_update_trail))
      flash[:notice] = "Your client information was saved."
      redirect_back_or_default
    end
  end

  def delete
    client = our_client(params[:id])
    return if client.nil?

    client.destroy
    redirect_back_or_default
  end

private

  def populate_name_from_create_invoice
    @client.name = session[:document_client_name].blank? ? "" : session[:document_client_name]
    session[:document_client_name] = nil
  end

  def apply_excel_header
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = "attachment;filename=#{generate_excel_filename}"
  end     

  def generate_excel_filename
    s = "#{@app_config['app_name']}Clients.xls"
  end
  
  def render_different_formats
    case params[:format]
      when "xml":
        render :template => "clients/export/#{action_name}.rxml", :layout => false
        return true
      when "xls":
        apply_excel_header
        render :template => "clients/export/#{action_name}.rxls", :layout => false
        return true
    end
  end
end
