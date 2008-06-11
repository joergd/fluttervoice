require 'obfuscator'

class SummaryController < ApplicationController

  def index
    begin
      action = Obfuscator::decrypt(params[:a])
      id = Obfuscator::decrypt(params[:id])
    rescue
      logger.error("Error handling obfuscation")
      logger.error($!)
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end

    if %w{ show }.include?(action)
      self.method(action).call(id)
    else
      logger.error("Unknown command for summary. Intrusion??")
      logger.error($!)
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end
  end

private

  def show(id)
    @invoice = Invoice.find_by_id_and_account_id(id, @account.id)
    flash[:error] = 'Invalid invoice' if @invoice.nil?

    @logo = @account.preference.logo if !@account.preference.nil?
    render :template => "summary/show"
  end

end
