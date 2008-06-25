class HomeController < ApplicationController

  def uptime
    render :text => "success" if @tax = Tax.find(:first)
  end

  def index
    if !main_site?
      redirect_to :controller => 'invoices'
    else
      @user = User.new
      plans = find_plans
      @max_free_invoices = plans[3].invoices
      @cheapest = plans[2].display_cost(@app_config['site'])
      @top = plans[0].display_cost(@app_config['site'])
      render :layout => "homepage"
    end
  end
  
  def examples
  end

  def cancelled
    render :layout => "homepage"
  end
end
