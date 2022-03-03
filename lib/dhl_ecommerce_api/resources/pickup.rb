module DHLEcommerceAPI
  class Pickup < Base
    # example_pickup_params = {
    #   "handover_items": [
    #     {
    #       "pickup_date": "2022-03-05",
    #       "pickup_start_time": "09:00",
    #       "pickup_end_time": "18:00",
    #       "shipment_type": "1",
    #       "notification_email": nil,
    #       "shipper_details": {
    #         "company": "PostCo",
    #         "name": "PostCo",
    #         "email_id": nil,
    #         "phone_number": "0169822645",
    #         "address_line_1": "no 26 jalan 31/123, petaling jaya",
    #         "address_line_2": nil,
    #         "address_line_3": nil,
    #         "city": "Kuala Lumpur",
    #         "state": "Kuala Lumpur",
    #         "postal_code": "57000",
    #         "country": "MY",
    #       },
    #       "shipments": {
    #         "quantity": 1,
    #         "totalWeight": 100
    #       }
    #     }
    #   ]
    # }

    self.format = :json
    self.prefix = "/rest/v2/Order/Shipment/Pickup"
    self.element_name = ""
    
    def initialize(attributes = {}, persisted = false)
      attributes = account_ids.merge(attributes)
      super
    end

    def create
      run_callbacks :create do
        connection.post(collection_path, formatted_request_data(request_data), self.class.headers).tap do |response|
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
        else
          error_messages = response_status["messageDetails"].map{|err| err["messageDetail"]}
          handle_errors(code, error_messages)
          @persisted = false
        end

        new_attributes = attributes.merge(bd)
        load(new_attributes, true, @persisted)
      end
    end

    def handle_errors(code, error_messages)
      errors.add(:base, "#{code} - #{error_messages.join(", ")}")
    end

    def request_data
      {
        "pickup_request": {
          "hdr": headers,
          "bd": attributes.except("response_status") # dont send responseStatus
        }
      }
    end
    
    def headers
      {
        "message_type": "PICKUP",
        "message_date_time": DateTime.now.to_s,
        "access_token": DHLEcommerceAPI::Authentication.get_token,
        "message_version": "1.2"
      }
    end

    def account_ids
      {
        "pickup_account_id": DHLEcommerceAPI.config.pickup_account_id,
        "sold_to_account_id": DHLEcommerceAPI.config.sold_to_account_id,
      }
    end

    # Since request_data isnt the same as object attributes. 
    # We have to write our own method to format the request data
    def formatted_request_data(request_data)
      request_data.as_json
        .deep_transform_keys do |key| 
          format_key(key) # method from Base
        end.to_json
    end
  end
end