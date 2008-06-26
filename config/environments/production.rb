# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger        = SyslogLogger.new


# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

config.action_view.cache_template_loading = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors if you bad email addresses should just be ignored
# config.action_mailer.raise_delivery_errors = false

config.action_mailer.smtp_settings = {
  :address => "localhost",
  :port => 25,
  :domain => "fluttervoice.co.za"
}


PAYMENT_GATEWAY_USR = "BREA.KF28C944E4BC1"
PAYMENT_GATEWAY_PWD = "0E35B6AA2"
