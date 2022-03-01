module DHLEcommerceAPI
  class ShipmentCreation < Base
    self.format = :json
    self.prefix = "/rest/v3/Shipment"
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
        
        # depending on the error response from DHL, add errors to the model
        handle_errors(response)

        json = self.class.format.decode(response.body)["bd"]
        new_attributes = attributes.merge(json)

        load(new_attributes, true, true)
        @persisted = true
      end
    end

    def handle_errors(response)
      json = JSON.parse(response.body)
      status = json["manifestResponse"]["bd"]["responseStatus"]
      code = status["code"]
      if code != "200"
        error_messages = status["messageDetails"].map{|err| err["messageDetail"]}
        errors.add(:base, "#{code} - #{error_messages.join(", ")}") unless error_messages.empty? 
      end
    end

    def request_data
      {
        "manifest_request": {
          "hdr": headers,
          "bd": attributes.except("response_status") # dont send responseStatus
        }
      }
    end
    
    def headers
      {
        "message_type": "SHIPMENT",
        "message_date_time": DateTime.now.to_s,
        "access_token": DHLEcommerceAPI::Authentication.get_token,
        "message_version": "1.0"
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

    def is_pickup?
      self.handover_method.to_i == 2
    end
  end
end