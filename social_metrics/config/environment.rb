# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

Instagram.configure do |config|
  config.client_id = "668c24e10ec64dca9acc1353861ad072"
  config.client_secret = "43cdfa54b7c046e1a80bad4aecf27ce7"
  # For secured endpoints only
  #config.client_ips = '<Comma separated list of IPs>'
end