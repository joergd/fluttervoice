ActionController::Routing::Routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.

  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # You can have the root of your site routed by hooking up ''
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "home"
  map.connect 'cancelled', :controller => "home", :action => "cancelled"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

	map.connect 'account/logo/:id',
			  :controller => 'account',
			  :action => 'logo', :id => /.*\.gif/

  # /^.*\.gif$/ .... used to be that

	map.connect 'summary/:a/:id', :controller => "summary", :action => "index"

	# this is more to run the tests really ... don't know how to 'get' or 'post' to an empty-string action
	map.connect 'summary/index/:a/:id', :controller => "summary", :action => "index"

  # handle invoice filters
  map.connect 'invoices/:states', :controller => 'invoices',
                                  :action => 'index',
                                  :requirements => { :states => /([Aa]ll|[Oo]pen|[Oo]verdue|[Cc]losed).*/ } 

  # /^([Aa]ll|[Oo]pen|[Oo]verdue|[Cc]losed).*/ .... used to be that 

  map.namespace(:adm1n) do |adm1n|
    adm1n.home "/", :controller => "home", :action => "index"
    adm1n.resources :manual_interventions, :member => { :complete => :post }
    adm1n.resources :accounts
  end
    

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'

end
