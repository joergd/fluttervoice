class Adm1n::AccountsController < Adm1n::ApplicationController

  def index
    @accounts = params[:q].blank? ? [] : Account.find(:all, :conditions => ["subdomain LIKE :query", { :query => "%#{params[:q]}%" }], :order => "subdomain ASC")
  end
  
  def show
    @account = Account.find(params[:id])
  end
end
