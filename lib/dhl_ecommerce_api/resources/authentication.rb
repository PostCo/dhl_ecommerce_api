module DHLEcommerceAPI
  class Authentication < ActiveResource::Base
    # self.prefix set in configuration.rb 
    def self.get_token
      token = DHLEcommerceAPI.cache.read("DHLEcommerceAPI::AuthenticationToken")
      if token.present?
        return token
      else
        path = "/rest/v1/OAuth/AccessToken?clientId=#{DHLEcommerceAPI.config.client_id}&password=#{DHLEcommerceAPI.config.password}&returnFormat=json"
        response = connection.get(path)
        response_body = JSON.parse(response.body)["accessTokenResponse"]
        DHLEcommerceAPI.cache.write("DHLEcommerceAPI::AuthenticationToken", response_body["token"], {expires_in: 12.hours})
        return response_body["token"]
      end
    end
  end
end