class DocumentsController < ApplicationController
  before_filter :login_required

  def get_currency_symbol
    currency = Currency.find(params[:currency])
    render :text => currency.nil? ? '' : currency.symbol, :layout => false
  end

private

  def line_item_messages(errors)
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
    @line_item_types = LineItemType.find(:all, :order => 'position')
    @last_invoice_number_used = Invoice.last_number_used(@account.id)
  end

  def extract_lines_from_params
    line_items = Array.new
    if !params[:line_items].nil?
      params[:line_items].each do |line_no, attr|
        line_item = LineItem.new(attr.merge(audit_create_trail))
        line_item.account_id = @account.id
        line_items << line_item
      end
    end
    return line_items
  end

  def session_variables_present?
    if session[:client_id].nil?
      flash[:notice] = "Please select a client for your new invoice"
      redirect_to :action => 'create'
      return false
    end
    return true
  end

  def save_document(document, line_items)
    # need this check here, else we clear the line items, never to see them again.
    if line_items.size == 0
      document.errors.add(:line_items, "not there. You need at least one line item")
      return false
    end
    begin
      LineItem.transaction do
        document.class.transaction do
          document.line_items.clear
          document.line_items = line_items
          document.line_items.each do |line_item|
            if !line_item.valid?
              document.errors.add(:line_items, line_item_messages(line_item.errors).join(", "))
              return false
            end
          end
          if document.save
            flash[:notice] = "Your #{document.class.to_s.downcase} has been saved. You can send it by clicking 'Send #{document.class.to_s}'"
            redirect_to :action => 'show', :id => document.id
            session[:client_id] = nil
            return true
          end
        end
      end
      return false
    rescue
      flash[:error] = "Error saving #{document.class.to_s.downcase}: Please try again in a few minutes."
      logger.error("Error saving #{document.class.to_s.downcase}")
      logger.error($!)
      return false
    end
  end

  def log_email(email_type, document, to, amount_due=nil)
    begin
      email_log = EmailLog.new({ :account_id => document.account_id, :document_id => document.id, :client_id => document.client_id })
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

  def deliver(email_type, email, document)
     if DocumentMailer.deliver(email)
       log_email(email_type, document, email.to.join(", "), document.total)
       flash[:notice] = "Your email was sent successfully"
     else
       flash[:error] = "There was a problem sending your email. We have logged this error and will try and figure out what's going on."
      logger.error("Error sending document")
      logger.error($!)
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

  def construct_email_html_for_document(document)
    td_style = %Q(style="font-size: 12px; padding: 5px; border-bottom: 1px solid #E4E4D2;")
    th_style = %Q(style="font-size: 12px; padding: 5px;")
    s = render_to_string(:partial => 'documents/show_invoice', :locals => { :invoice => document })
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
