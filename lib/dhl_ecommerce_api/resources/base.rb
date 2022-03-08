module DHLEcommerceAPI
  class Base < ActiveResource::Base
    # info returned - delivery_confirmation_no, delivery_depot_code, primary_sort_code, secondary_sort_code

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
      # convert loaded attributes to underscore, then symbolize
      attributes.deep_transform_keys! { |k| k.to_s.underscore.to_sym }

      # merge default_attrs(symbols) with incoming attributes
      if defined?(self.class::DEFAULT_ATTRIBUTES)
        attributes = self.class::DEFAULT_ATTRIBUTES.merge(attributes)
      end
      super
    end


    def attributes_with_account_ids
      account_ids.merge(attributes)
    end

    def account_ids
      {
        pickup_account_id: DHLEcommerceAPI.config.pickup_account_id,
        sold_to_account_id: DHLEcommerceAPI.config.sold_to_account_id,
      }
    end

    def handle_errors(code, error_messages)
      errors.add(:base, "#{code} - #{error_messages.join(", ")}")
    end
    
    # Since request_data isnt the same as object attributes. 
    # We have to write our own method to format the request data
    def formatted_request_data(request_data)
      request_data.as_json
        .deep_transform_keys {|key| custom_key_format(key)}.to_json
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