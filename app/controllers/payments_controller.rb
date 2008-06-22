class PaymentsController < ApplicationController
  before_filter :login_required

  def new
    # id represents the invoice id.
    # verify that invoice belongs to account
    @invoice = our_document(params[:id])
    return if @invoice.nil?

    @payment = Payment.new

    if request.get?
      return
    end

    # we reach this part if it was a POST and everything so far is cool
    @payment.attributes = params[:payment].merge(audit_create_trail)
    @payment.account_id = @account.id

    if @invoice.payments << @payment
      flash[:notice] = 'Payment was successfully received.'
      redirect_back_or_default
    end
  end

  def list
    # id represents the invoice id.
    # verify that invoice belongs to account
    @invoice = our_document(params[:id])
    return if @invoice.nil?
  end

  def delete
    payment = our_payment(params[:id])
    return if payment.nil?

    payment.destroy
    redirect_back_or_default
  end
end
