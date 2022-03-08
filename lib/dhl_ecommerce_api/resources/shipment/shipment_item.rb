module DHLEcommerceAPI
  # Component item
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
      }
    }

    def initialize(attributes = {}, persisted = false)
      status = attributes["response_status"]
      if status.present? && status["code"] != "200"
        error_messages = status["message_details"].map{|err| err["message_detail"]}
        handle_errors(status["code"], error_messages) 
      end
      super
    end
  end
end