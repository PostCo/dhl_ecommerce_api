module DHLEcommerceAPI
  class Base < ActiveResource::Base
    # info returned - delivery_confirmation_no, delivery_depot_code, primary_sort_code, secondary_sort_code

    self.include_format_in_path = false
    self.connection_class = Connection

    def attributes_with_account_ids
      account_ids.merge(attributes)
    end

    def account_ids
      {
        "pickupAccountId": DHLEcommerceAPI.config.pickup_account_id,
        "soldToAccountId": DHLEcommerceAPI.config.sold_to_account_id,
      }
    end

    def handle_errors(code, error_messages)
      errors.add(:base, "#{code} - #{error_messages.join(", ")}")
    end

    # custom keys that arent following lowerCamel convention
    def custom_key_format(key)
      case key.to_s
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