module DHLEcommerceAPI
  class Shipment::Dropoff < Shipment
    # This creates a Shipment ONLY. 
    # DHL will expect the item to be dropped off at one of their locations.
    # Used in conjunction with the Pickup class.

    self.element_name = ""

    DEFAULT_ATTRIBUTES = {
      handover_method: 1,
      shipment_items: []
    }
  end
end

# shipment_with_dropoff_params = {
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
#       "shipment_id" => "MYPTC000103",
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
