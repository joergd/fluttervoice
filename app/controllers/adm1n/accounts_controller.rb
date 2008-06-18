class Adm1n::AccountsController < Adm1n::ApplicationController

  def index
    @accounts = params[:q].blank? ? [] : Account.find(:all, :conditions => ["subdomain LIKE :query", { :query => "%#{params[:q]}%" }], :order => "subdomain ASC")
  end
  
  def paying
    @accounts = params[:q].blank? ? Account.paying.find(:all) : Account.paying.find(:all, :conditions => ["subdomain LIKE :query", { :query => "%#{params[:q]}%" }])
  end

  def latest
    @accounts = Account.find(:all, :limit => 20, :order => "created_on DESC")
  end
  
  def show
    @account = Account.find_with_deleted(params[:id])
  end
end
