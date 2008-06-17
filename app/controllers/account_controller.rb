class AccountController < ApplicationController
  before_filter :login_required
  after_filter :store_location, :except => [:edit, :logo, :export]

  caches_page :logo

  def index
    @plans = find_plans
  end

  def edit
    if !primary_user?
      flash[:notice] = "You need to be the main user for the account to change the company information."
      redirect_to :action => 'index'
      return
    end
    if request.post?
      if @account.update_attributes(params[:account].merge(audit_update_trail))
        flash[:notice] = "Your company information was saved."
        redirect_to :action => 'index'
      end
    end
  end

  def logo
    id = params[:id].to_s[/\d.*/]
    image = Image.find_by_id_and_account_id(id, @account.id)
    if !image.nil?
      send_data image.binary.data,
          :filename => "#{params[:id]}",
          :type => 'image/gif',
          :disposition => 'inline'
    else
      render :nothing => true
    end
  end

  def export
    @clients = @account.clients
    @invoices = @account.invoices
    case params[:format]
      when "xml":
        render :template => "account/export/#{action_name}.rxml", :layout => false
        return true
      when "xls":
        apply_excel_header
        render :template => "account/export/#{action_name}.rxls", :layout => false
        return true
    end
  end

  def cancel
  end

  def destroy
    if request.get? || (params[:id] && params[:id].to_s != @account.id.to_s)
      # should never happen
      redirect_to :action => "cancel"
      return
    end
    @account.destroy
    reset_session
    redirect_to "http://www.#{@app_config['domain']}/cancelled"
  end
    
private

  def apply_excel_header
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = "attachment;filename=#{generate_excel_filename}"
  end     

  def generate_excel_filename
    s = "#{@app_config['app_name']}Export.xls"
  end
  

end
