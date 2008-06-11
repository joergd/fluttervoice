module PlanSystem

protected

  def invoice_limit_reached?
    if @account.invoice_limit_reached?
      @plans = find_plans
      render :template => '/limit_reached/invoices'
      return false
    end
  end

  def client_limit_reached?
    if @account.client_limit_reached?
      @plans = find_plans
      render :template => '/limit_reached/clients'
      return false
    end
  end

  def user_limit_reached?
    # id represents the client id.
    # if it is empty, then we are creating a user for the account
    if params[:id].nil? && @account.user_limit_reached?
      @plans = find_plans
      render :template => '/limit_reached/users'
      return false
    end
  end
end
