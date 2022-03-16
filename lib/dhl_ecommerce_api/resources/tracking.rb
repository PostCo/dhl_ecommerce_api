module DHLEcommerceAPI
  class Tracking < Base
    self.prefix = "/rest/v3/Tracking"
    self.element_name = ""
    
    def initialize(attributes = {}, persisted = false)
      attributes = account_ids.merge(attributes)
      super
    end

    def self.find(arguments)
      tracking = self.new({
        "ePODRequired": "Y",
        "trackingReferenceNumber": arguments.is_a?(Array) ? arguments : [arguments]
      })
      tracking.save
        
      return tracking.shipment_items.presence || []
    end

    def create
      run_callbacks :create do
        connection.post(collection_path, request_data.to_json, self.class.headers).tap do |response|
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
        new_attributes = new_attributes.merge({shipment_items: bd["shipmentItems"]})
        
        load(new_attributes, true, @persisted)
      end
    end
    
    def request_data
      {
        "trackItemRequest": {
          "hdr": headers,
          "bd": attributes.except("response_status") # dont send responseStatus
        }
      }
    end
    
    def headers
      {
        "messageType": "TRACKITEM",
        "messageDateTime": DateTime.now.to_s,
        "accessToken": DHLEcommerceAPI::Authentication.get_token,
        "messageVersion": "1.0"
      }
    end
  end
end

=begin
example_tracking_params = {
  "ePODRequired": "Y", 
  "trackingReferenceNumber": [
      "MYPTC00012", "MYPTC00013"
  ]
}
=end