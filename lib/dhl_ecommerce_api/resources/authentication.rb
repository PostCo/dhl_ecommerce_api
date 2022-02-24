module DHLEcommerceAPI
  class Authentication < ActiveResource::Base
    self.site = DHLEcommerceAPI::Base.site
    self.prefix = "/rest/v1/OAuth/AccessToken?clientId=#{ENV["DHL_ECOMMERCE_API_CLIENT_ID"]}&password=#{ENV["DHL_ECOMMERCE_API_PASSWORD"]}&returnFormat=json"
  end
end