require "dotenv/load"

def set_config
  DHLEcommerceAPI.configure do |config|
    config.env = :sandbox
    config.client_id = ENV["DHL_ECOMMERCE_API_CLIENT_ID"]
    config.password = ENV["DHL_ECOMMERCE_API_PASSWORD"]
    config.pickup_account_id = ENV["DHL_ECOMMERCE_API_PICKUP_ACCOUNT_ID"]
    config.soldto_account_id = ENV["DHL_ECOMMERCE_API_SOLDTO_ACCOUNT_ID"]
  end
end