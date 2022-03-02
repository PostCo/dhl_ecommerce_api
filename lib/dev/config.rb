require "dotenv/load"

def set_config
  DHLEcommerceAPI.configure do |config|
    config.client_id = ENV["DHL_ECOMMERCE_API_CLIENT_ID"]
    config.password = ENV["DHL_ECOMMERCE_API_PASSWORD"]
    config.pickup_account_id = ENV["DHL_ECOMMERCE_API_PICKUP_ACCOUNT_ID"]
    config.sold_to_account_id = ENV["DHL_ECOMMERCE_API_SOLD_TO_ACCOUNT_ID"]
    config.env = ENV["DHL_ECOMMERCE_API_ENV"] || "sandbox"
  end
end