class Adm1n::AccountsController < Adm1n::ApplicationController

  def index
  end
  
  def show
    @account = Account.find(params[:id])
  end
end
