module DHLEcommerceAPI
  class ShipmentCreation < Base
    self.prefix = "/rest/v3/Shipment"
    self.element_name = ""

    WRAPPER_KEY = "manifestRequest"

    attr_reader :token

    def initialize(attributes = {}, persisted = false)
      @token = get_token
      attributes = {
        "pickupAccountId": "5264484741",
        "soldToAccountId": "5264484741",
        "pickupDateTime": "",
        "handoverMethod": "1",
        "pickupAddress": {
            "companyName": "",
            "name": "",
            "address1": "",
            "address2": "",
            "address3": "",
            "city": "",
            "state": "",
            "country": "",
            "postCode": "",
            "phone": "",
            "email": ""
        },
        "shipmentItems": [
          {
            "consigneeAddress": {
              "companyName": "Bikerzxcess",
              "name": "MUHAMMAD JEFFRY TAN",
              "address1": "NO 3 JALAN PPU 1",
              "address2": "TAMAN PERINDUSTRIAN PUCHONG UTAMA",
              "address3": nil,
              "city": "PUCHONG",
              "state": "SELANGOR",
              "district": nil,
              "country": "MY",
              "postCode": "47100",
              "phone": "0123456798",
              "email": nil
            },
            "shipmentID": "MYPOC00010",
            "packageDesc": "SUPRIMA S",
            "totalWeight": 3000,
            "totalWeightUOM": "G",
            "dimensionUOM": "CM",
            "height": nil,
            "length": nil,
            "width": nil,
            "productCode": "PDO",
            "codValue": nil,
            "insuranceValue": nil,
            "totalValue": 300,
            "currency": "MYR",
            "remarks": nil,
            "isRoutingInfoRequired": "Y"
          },
        ]
      }
      
      # set attributes for the request
      attributes = {
        "manifestRequest": {
          
        }
        hdr: request_headers,
        bd: request_body.merge(attributes)
      }
      
      super
    end

    def create
      run_callbacks :create do
        binding.pry
        connection.post(collection_path, ActiveSupport::JSON.encode(generate_request), self.class.headers).tap do |response|
          load_attributes_from_response(response)
        end
      end
    end

    def load_attributes_from_response(response)
      if response_code_allows_body?(response.code.to_i) &&
          (response["Content-Length"].nil? || response["Content-Length"] != "0") &&
          !response.body.nil? && response.body.strip.size > 0

        attributes.delete("request_body")
        
        # convert hdr to headers, bd to body
        json = self.class.format.decode(response.body)
        json = {
          headers: json.delete('hdr'),
          body: json.delete('bd')
        }

        load(json, true, true)
        @persisted = true
      end
    end

    def to_json(options = {})
      attributes.as_json.deep_transform_keys { |k| k.to_s.camelize(:lower) }
        .to_json(include_root_in_json ? {root: self.class.element_name}.merge(options) : options)
    end
    
    private

    def get_token
      return DHLEcommerceAPI.cache.fetch("DHLEcommerceAPIToken", expires_in: 12.hours) do
        response = Authentication.get(:_)
        response["token"]
      end
    end

    def generate_request
      {
        "manifestRequest": {
          "hdr": request_headers,
          "bd": attributes
        }
      }
    end

    def request_headers
      {
        "messageType": "SHIPMENT",
        "messageDateTime": DateTime.now.to_s,
        "accessToken": token,
        "messageVersion": "1.0",
        "messageLanguage": "en"
      }
    end

    def request_body
      {
        "pickupAccountId": "5264484741",
        "soldToAccountId": "5264484741",
        "pickupDateTime": "",
        "handoverMethod": "",
        "pickupAddress": {
            "companyName": "",
            "name": "",
            "address1": "",
            "address2": "",
            "address3": "",
            "city": "",
            "state": "",
            "country": "",
            "postCode": "",
            "phone": "",
            "email": ""
        },
        "shipmentItems": []
      }
    end

  end
end