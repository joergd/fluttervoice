app_name = "fluttervoice.co.za"
app_root = "/users/home/joergd/domains/#{app_name}"
CONFIG[:lighttpd_data][app_name] = <<LIGHTTPD_CONFIG
  $HTTP["host"] =~ ".*.?fluttervoice\.(com|co\.za|co\.uk)$" {
    server.document-root = "#{app_root}/current/public/" 
    server.errorlog = "#{app_root}/shared/log/lighttpd.error.log" 
    accesslog.filename = "#{app_root}/shared/log/lighttpd.access.log" 

    url.rewrite = ( "^/$" => "index.html", "^([^.]+)$" => "$1.html" )
    server.error-handler-404 = "/dispatch.fcgi" 

    fastcgi.server = ( ".fcgi" =>
      ( "localhost" =>
    ("socket"   => "#{app_root}/shared/tmp/lighttpd-fcgi-0.socket"),
    ("socket"   => "#{app_root}/shared/tmp/lighttpd-fcgi-1.socket")
      )
    )
  } 
LIGHTTPD_CONFIG

CONFIG[:spawners][app_name] = proc do 
  puts "spawning processes for #{app_name}"
  rm_rf "#{app_root}/shared/tmp"
  mkdir_p "#{app_root}/shared/tmp"
  ENV["RAILS_ENV"] = "production"
  2.times do |i|
    system "/usr/local/bin/spawn-fcgi -f #{app_root}/current/public/dispatch.fcgi -s" +
        " #{app_root}/shared/tmp/lighttpd-fcgi-#{i}.socket -P" +
        " #{app_root}/shared/tmp/lighttpd-fcgi-#{i}.pid"
  end
end

CONFIG[:stoppers][app_name] = proc do
  puts "stopping processes for #{app_name}"
  2.times do |i|
    if File.exists?("#{app_root}/shared/tmp/lighttpd-fcgi-#{i}.pid")
      system "kill -9 `cat #{app_root}/shared/tmp/lighttpd-fcgi-#{i}.pid`"
    else
      puts "Nothing to stop for #{app_name}(#{i})"
    end
  end
end
