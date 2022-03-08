module DHLEcommerceAPI
  class Shipment::Pickup < Shipment
    # This is a coupled shipment + pickup request.

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

#   ]
# }