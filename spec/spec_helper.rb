# frozen_string_literal: true

require "webmock/rspec"
require "pry"

require "dhl_ecommerce_api"
require "resources/authentication"
require "resources/shipment"

# WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  
  # Set test DHL env
  DHLEcommerceAPI.configure do |config|
    config.client_id = "test"
    config.password = "test"
    config.env = "development"
  end
end
