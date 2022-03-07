# frozen_string_literal: true

require_relative "dhl_ecommerce_api/version"
require "active_resource"

module DHLEcommerceAPI
  require "dhl_ecommerce_api/cache"
  require "dhl_ecommerce_api/configuration"
  require "dhl_ecommerce_api/connection"
  
  require "dhl_ecommerce_api/resources/base"
  require "dhl_ecommerce_api/resources/authentication"

  require "dhl_ecommerce_api/resources/shipment"
  require "dhl_ecommerce_api/resources/pickup"
  require "dhl_ecommerce_api/resources/tracking"
end
