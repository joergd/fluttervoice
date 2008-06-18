class Adm1n::CreditCardTransactionsController < Adm1n::ApplicationController
  def index
    @credit_card_transactions = params[:q].blank? ? CreditCardTransaction.find(:all, :order => "created_on DESC") : CreditCardTransaction.find(:all, :conditions => ["reference LIKE :query", { :query => "%#{params[:q]}%" }], :order => "created_on DESC")
  end
end
