module DHLEcommerceAPI
  class Shipment::Pickup < Shipment
    # This is a coupled shipment + pickup request.

    self.element_name = ""

    DEFAULT_ATTRIBUTES = {
      handover_method: 2,
      pickup_date_time: nil,
      pickup_address: {
        company_name: "",
        name: "",
        address1: "",
        address2: nil,
        address3: nil,
        city: "",
        state: "",
        post_code: "",
        country: "MY",
        phone: "",
        email: nil
      },
      shipment_items: []
    }

    validates_presence_of :pickup_date_time
  end
end

# shipment_with_pickup_params = {
#   "handoverMethod": 2,
#   "pickupDateTime": DateTime.now.to_s,
#   "pickupAddress": {
#     "companyName": "Pickup From Company",
#     "name": "Pickup From Name",
#     "address1": "Holistic Pharmacy PostCo, 55, Jalan Landak",
#     "address2": "",
#     "address3": "",
#     "city": " Kuala Lumpur",
#     "state": " Kuala Lumpur",
#     "postCode": "55100",
#     "country": "MY",
#     "phone": "0169822645",
#     "email": "erwhey@postco.co"
#   },
#   "shipmentItems": [
#     {
#       "shipmentID": "MYPTC0087",
#       "packageDesc": "Laptop Sleeve",
#       "totalWeight": 500,
#       "totalWeightUOM": "G",
#       "dimensionUOM": "CM",
#       "height": nil,
#       "length": nil,
#       "width": nil,
#       "productCode": "PDO",
#       "codValue": nil,
#       "insuranceValue": nil,
#       "totalValue": 300,
#       "currency": "MYR",
#       "remarks": nil,
#       "isRoutingInfoRequired": "Y",
#       "consigneeAddress": {
#         "companyName": "Sleeve Company",
#         "name": "Sleeve Sdn Bhd",
#         "address1": "No. 3, Jalan Bangsar, Kampung Haji Abdullah Hukum",
#         "address2": nil,
#         "address3": nil,
#         "city": "Kuala Lumpur",
#         "state": "Kuala Lumpur",
#         "district": nil,
#         "country": "MY",
#         "postCode": "59200",
#         "phone": "0169822645",
#         "email": nil
#       }
#     },
#   ]
# }