class PreferencesController < ApplicationController
  before_filter :login_required
  before_filter :primary_user_required

  def index
    @currencies = Currency.find(:all, :order => 'name')
    @taxes = Tax.find(:all)
    @terms = Term.find(:all, :order => 'days')
    
    @preference = @account.preference
    @logo = @preference.logo if !@preference.nil?
    
    if request.get?
      return
    end
  
    if @preference.update_attributes(params[:preference].merge(audit_update_trail))
      flash[:notice] = "Your preferences were saved."
    end
  end

  def templates
    @templates = SystemDocumentTemplate.find(:all)
    
    if request.get?
      @preference = @account.preference
      return
    end
    
     @preference = @account.preference
    if @account.preference.update_attributes(params[:preference].merge(audit_update_trail))
      flash[:notice] = "Your invoice template preferences were saved."
    end
  end

  def thankyous
    if request.get?
      @preference = @account.preference
      return
    end
    
     @preference = @account.preference
    if @account.preference.update_attributes(params[:preference].merge(audit_update_trail))
      flash[:notice] = "Your thank you message was saved."
    end
  end
  
  def invoicenotes
    if request.get?
      @preference = @account.preference
      return
    end
    
    @preference = @account.preference
    if @account.preference.update_attributes(params[:preference].merge(audit_update_trail))
      flash[:notice] = "Your invoice notes were saved."
    end
  end
  
  def upload_logo
    @preference = @account.preference
    @image = @preference.logo
    
    @image ||= Image.new({ :account_id => @account.id }.merge(audit_create_trail))

    begin
      @image.attributes = { :logo_file => params[:image_file]}.merge(audit_update_trail)  
    rescue
      logger.error("Error uploading logo #{@image.original_filename}")
      logger.error($!)
      flash[:error] = 'There was an error uploading your logo.'
      redirect_to :action => 'index'
      return
    end
    
    begin    
      Preference.transaction do
        Image.transaction do
          if !@image.errors.empty? || !@image.save
            logger.error("Error saving logo #{@image.original_filename}")
            logger.error(@image.errors.full_messages.join("; "))
            flash[:error] = 'There was an error saving your logo.'
            redirect_to :action => 'index'
            return
          end
          if !@preference.update_attributes({ :logo_image_id => @image.id }.merge(audit_update_trail))
            logger.error("Error saving logo id to preferences")
            flash[:error] = 'There was an error saving your logo.'
            redirect_to :action => 'index'
            return
          end
        end
      end
    rescue
      flash[:error] = "Error uploading logo. Please try again in a few minutes"
      logger.error("Error uploading logo")
      logger.error($!)
    end

    expire_cached_logo @image.id
    redirect_to :action => 'index'
  end

  def delete_logo
    preference = @account.preference
    if preference.logo && preference.logo.destroy
      preference.update_attributes({ :logo_image_id => 0}.merge(audit_update_trail))
    end
    redirect_to :action => 'index'
  end
end

private
  
  def primary_user_required
    if !primary_user?
      flash[:notice] = "You need to be the main user for the account to change the settings."
      redirect_to :controller => 'account', :action => 'index'
      return
    end
  end
  
  def expire_cached_logo(id)
    expire_page :controller => 'account',
       :action => 'logo',
       :id => "#{id}.gif"
  end
