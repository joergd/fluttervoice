module ActiveMerchant
  module PostsData
    
    def included?(base)
      base.class_eval do
        attr_accessor :ssl_strict
      end
    end
      
    def ssl_post(url, data)
      uri   = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port) 

      http.verify_mode    = OpenSSL::SSL::VERIFY_NONE unless @ssl_strict
      http.use_ssl        = true

      ActiveRecord::Base.logger.warn "SSL Posted to: " + uri.host + uri.path
      ActiveRecord::Base.logger.warn "SSL Posted: " + data

      http.post(uri.path, data, { "Content-Type" => "application/x-www-form-urlencoded" }).body      
    end    
  end
end