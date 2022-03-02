module DHLEcommerceAPI
  class Authentication < ActiveResource::Base
    # self.prefix set in configuration.rb 

    def self.get_token
      token = DHLEcommerceAPI.cache.read("DHLEcommerceAPIToken")
      if token.present? 
        return token
      else
        response = get(:token)
        DHLEcommerceAPI.cache.write("DHLEcommerceAPIToken", response["token"])
        return response["token"]
      end
    end
  end
end