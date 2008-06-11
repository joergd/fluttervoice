app_name = "fluttervoice.co.za"
app_root = "/users/home/joergd/domains/#{app_name}"
CONFIG[:lighttpd_data][app_name] = <<LIGHTTPD_CONFIG
  $HTTP["host"] =~ ".*.?fluttervoice\.(com|co\.za|co\.uk)$" {
    server.document-root = "#{app_root}/current/public/system" 
    server.errorlog = "#{app_root}/shared/log/lighttpd.error.log" 
    accesslog.filename = "#{app_root}/shared/log/lighttpd.access.log" 

    url.rewrite = ( "^.*$" => "maintenance.html" )
    server.error-handler-404 = "/maintenance.html" 

  } 
LIGHTTPD_CONFIG
