module DHLEcommerceAPI
  class Base < ActiveResource::Base
    self.format = :json
    self.include_format_in_path = false
    self.connection_class = Connection

    # by default convert to lowerCamelcase before sending request
    def to_json(options = {})
      attributes.as_json
        .deep_transform_keys { |k| k.to_s.camelize(:lower) }
        .to_json(include_root_in_json ? { root: self.class.element_name }.merge(options) : options)
    end

    # by default convert to snake_case when initializing
    def load(attributes, remove_root = false, persisted = false)
      attributes.deep_transform_keys! { |k| k.to_s.underscore }
      super
    end

    def handle_errors(code, error_messages)
      errors.add(:base, "#{code} - #{error_messages.join(", ")}")
    end

    # custom keys that arent following lowerCamel convention
    def custom_key_format(key)
      case key
      when "shipment_id"
        "shipmentID"
      when "total_weight_uom"
        "totalWeightUOM"
      when "dimension_uom"
        "dimensionUOM"
      when "order_url"
        "orderURL"
      when "location_id"
        "locationID"
      when "piece_id"
        "pieceID"
      when "weight_uom"
        "weightUOM"
      when "marketplace_url"
        "marketplaceURL"
      when "handover_id"
        "handoverID"
      when "email_id"
        "emailID"
      when "e_pod_required"
        "ePODRequired"
      else
        key.to_s.camelize(:lower)
      end
    end
  end
end