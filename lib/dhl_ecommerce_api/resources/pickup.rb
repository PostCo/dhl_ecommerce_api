module DHLEcommerceAPI
  class Pickup < Base
    # This is a one-off pickup request. 
    # It simply tells DHL to pickup items from the shipper_details address.
    # Used in conjunction with the Shipment::Dropoff class. 

    self.prefix = "/rest/v2/Order/Shipment/Pickup"
    self.element_name = ""
    
    def create
      run_callbacks :create do
        connection.post(collection_path, pickup_request.to_json, self.class.headers).tap do |response|
          self.id = id_from_response(response)
          load_attributes_from_response(response)
        end
      end
    end

    def load_attributes_from_response(response)
      if response_code_allows_body?(response.code.to_i) &&
          (response["Content-Length"].nil? || response["Content-Length"] != "0") &&
          !response.body.nil? && response.body.strip.size > 0
        
        bd = self.class.format.decode(response.body)["bd"]
        response_status = bd["responseStatus"]
        code = response_status["code"]

        if code == "200"
          @persisted = true
        elsif code == "204"
          # handle partial success
          @persisted = false
        else
          error_messages = response_status["messageDetails"].map{|err| err["messageDetail"]}
          handle_errors(code, error_messages)
          @persisted = false
        end

        new_attributes = attributes.merge({response: JSON.parse(response.body)})
  
        load(new_attributes, true, @persisted)
      end
    end

    def pickup_request
      {
        "pickupRequest": {
          "hdr": headers,
          "bd": attributes_with_account_ids
        }
      }
    end
    
    def headers
      {
        "messageType": "PICKUP",
        "messageDateTime": DateTime.now.to_s,
        "accessToken": DHLEcommerceAPI::Authentication.get_token,
        "messageVersion": "1.2"
      }
    end
  end
end
=begin
pickup_params = {
  "handoverItems": [
    {
      "pickupDate": "2022-03-17",
      "pickupStartTime": "09:00",
      "pickupEndTime": "18:00",
      "shipmentType": "1",
      "notificationEmail": nil,
      "shipperDetails": {
        "company": "PostCo",
        "name": "PostCo",
        "emailID": nil,
        "phoneNumber": "0169822645",
        "addressLine1": "no 26 jalan 31/123, petaling jaya",
        "addressLine2": nil,
        "addressLine3": nil,
        "city": "Kuala Lumpur",
        "state": "Kuala Lumpur",
        "postalCode": "57000",
        "country": "MY",
      },
      "shipments": {
        "quantity": 1,
        "totalWeight": 100
      }
    }
  ]
}
=end