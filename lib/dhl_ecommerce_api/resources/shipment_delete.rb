module DHLEcommerceAPI
  class ShipmentDelete < Base
    self.prefix = "/rest/v2/Label/Delete"
    self.element_name = ""

    # Destroy a single shipment
    def self.destroy(shipment_id)
      request_params = delete_shipment_request(shipment_id)

      response = connection.post(collection_path, request_params.to_json, headers)
      
      data = JSON.parse(response.body)      
      data.dig("deleteShipmentResp", "bd", "shipmentItems")&.first
    end
  
    def self.delete_shipment_request(shipment_id)
      {
        "deleteShipmentReq": {
          "hdr": {
            "messageType": "DELETESHIPMENT",
            "messageDateTime": DateTime.now.to_s,
            "accessToken": DHLEcommerceAPI::Authentication.get_token,
            "messageVersion": "1.0"
          },
          "bd": {
            "pickupAccountId": DHLEcommerceAPI.config.pickup_account_id,
            "soldToAccountId": DHLEcommerceAPI.config.sold_to_account_id,
            "shipmentItems": [
              {
                "shipmentID": shipment_id
              }
            ]
          }
        }
      }
    end
  end
end

