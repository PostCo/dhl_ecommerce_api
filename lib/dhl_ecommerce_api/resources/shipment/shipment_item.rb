module DHLEcommerceAPI
  class Shipment::ShipmentItem < Base
    # add some validations?
    DEFAULT_ATTRIBUTES = { 
      shipment_id: nil,
      package_desc: "",
      total_weight: nil,
      total_weight_uom: "G",
      dimension_uom: "CM",
      height: nil,
      length: nil,
      width: nil,
      product_code: "PDO",
      cod_value: nil,
      insurance_value: nil,
      total_value: 300,
      currency: "MYR",
      remarks: nil,
      is_routing_info_required: "Y",
      consignee_address: { 
        company_name: "",
        name: "",
        address1: "",
        address2: nil,
        address3: nil,
        city: "",
        state: "",
        district: nil,
        country: "MY",
        post_code: "",
        phone: "",
        email: nil 
      },
    }
  end
end