module DHLEcommerceAPI
  class Shipment < Base
    # Base Shipment class
    # info returned - delivery_confirmation_no, delivery_depot_code, primary_sort_code, secondary_sort_code

    self.prefix = "/rest/v3/Shipment"
    self.element_name = ""

    def create
      run_callbacks :create do
        connection.post(collection_path, manifest_request.to_json, self.class.headers).tap do |response|
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

    def manifest_request
      {
        "manifestRequest": {
          "hdr": headers,
          "bd": attributes_with_account_ids
        }
      }
    end
    
    def headers
      {
        "messageType": "SHIPMENT",
        "messageDateTime": DateTime.now.to_s,
        "accessToken": DHLEcommerceAPI::Authentication.get_token,
        "messageVersion": "1.0"
      }
    end
  end
end

# Examples:
=begin 
shipment_with_pickup_params = {
  "handoverMethod": 2,
  "pickupDateTime": DateTime.now.to_s,
  "pickupAddress": {
    "companyName": "Pickup From Company",
    "name": "Pickup From Name",
    "address1": "Holistic Pharmacy PostCo, 55, Jalan Landak",
    "address2": "",
    "address3": "",
    "city": " Kuala Lumpur",
    "state": " Kuala Lumpur",
    "postCode": "55100",
    "country": "MY",
    "phone": "0123456789",
    "email": "hello@example.com"
  },
  "shipperAddress": {
    "companyName": "Pickup From Company",
    "name": "Pickup From Name",
    "address1": "Holistic Pharmacy PostCo, 55, Jalan Landak",
    "address2": "",
    "address3": "",
    "city": " Kuala Lumpur",
    "state": " Kuala Lumpur",
    "postCode": "55100",
    "country": "MY",
    "phone": "0123456789",
    "email": "hello@example.com"
  },
  "shipmentItems": [
    {
      "shipmentID": "MYPTC0083",
      "packageDesc": "Laptop Sleeve",
      "totalWeight": 500,
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
      "isRoutingInfoRequired": "Y",
      "consigneeAddress": {
        "companyName": "Sleeve Company",
        "name": "Sleeve Sdn Bhd",
        "address1": "No. 3, Jalan Bangsar, Kampung Haji Abdullah Hukum",
        "address2": nil,
        "address3": nil,
        "city": "Kuala Lumpur",
        "state": "Kuala Lumpur",
        "district": nil,
        "country": "MY",
        "postCode": "59200",
        "phone": "0169822645",
        "email": nil
      },
      "returnMode": "03",
      "returnAddress": {
        "companyName": "Pickup From Company",
        "name": "Pickup From Name",
        "address1": "Holistic Pharmacy PostCo, 55, Jalan Landak",
        "address2": "",
        "address3": "",
        "city": " Kuala Lumpur",
        "state": " Kuala Lumpur",
        "postCode": "55100",
        "country": "MY",
        "phone": "0123456789",
        "email": "hello@example.com"
      }
    },
  ]
}
=end

# shipment_with_dropoff_params = {
#   "handover_method" => 1,
#   "shipment_items" => [
#     { 
#       "consignee_address" => { 
#         "company_name" => "Test",
#         "name" => "Test1",
#         "address1" => "NO 3 JALAN PPU 1",
#         "address2" => "TAMAN PERINDUSTRIAN PUCHONG UTAMA",
#         "address3" => nil,
#         "city" => "PUCHONG",
#         "state" => "SELANGOR",
#         "district" => nil,
#         "country" => "MY",
#         "post_code" => "57000",
#         "phone" => "0123456798",
#         "email" => nil 
#       },
#       "shipment_id" => "MYPTC000102",
#       "package_desc" => "Bread Materials",
#       "total_weight" => 2000,
#       "total_weight_uom" => "G",
#       "dimension_uom" => "CM",
#       "height" => nil,
#       "length" => nil,
#       "width" => nil,
#       "product_code" => "PDO",
#       "cod_value" => nil,
#       "insurance_value" => nil,
#       "total_value" => 300,
#       "currency" => "MYR",
#       "remarks" => nil,
#       "is_routing_info_required" => "Y" 
#     }
#   ],
# }
