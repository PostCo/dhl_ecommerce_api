module DHLEcommerceAPI
  class ShipmentCreation < Base
    self.prefix = "/rest/v3/Shipment"
    self.element_name = ""

    attr_reader :token

    def initialize(attributes = {}, persisted = false)
      super
    end

    def create
      run_callbacks :create do
        connection.post(collection_path, ActiveSupport::JSON.encode(generate_request), self.class.headers).tap do |response|
          load_attributes_from_response(response)
        end
      end
    end

    def load_attributes_from_response(response)
      if response_code_allows_body?(response.code.to_i) &&
         (response["Content-Length"].nil? || response["Content-Length"] != "0") &&
         !response.body.nil? && response.body.strip.size > 0

        # convert hdr to headers, bd to body
        json = self.class.format.decode(response.body)
        json = {
          headers: json.delete("hdr"),
          body: json.delete("bd"),
        }
        load(json, true, true)
        @persisted = true
      end
    end

    def to_json(options = {})
      attributes.as_json.deep_transform_keys { |k| k.to_s.camelize(:lower) }
        .to_json(include_root_in_json ? { root: self.class.element_name }.merge(options) : options)
    end

    def generate_request
      {
        manifestRequest: {
          hdr: request_headers,
          bd: request_body,
        },
      }
    end

    def request_headers
      {
        messageType: "SHIPMENT",
        messageDateTime: DateTime.now.to_s,
        accessToken: Authentication.get_token,
        messageVersion: "1.0",
      }
    end

    def request_body
      {
        pickupAccountId: DHLEcommerceAPI.config.pickup_account_id,
        soldToAccountId: DHLEcommerceAPI.config.soldto_account_id,
      }.merge(attributes)
    end
  end
end
