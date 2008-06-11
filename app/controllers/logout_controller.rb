class LogoutController < ApplicationController

  def index
    reset_session
    redirect_to :controller => 'login', :action => 'index'
  end
  
end
