module DHLEcommerceAPI
  class Tracking::ShipmentItem::Event < Base
    STATUS_CODES = {
      "71005": "awaiting_parcel_handover_to_dhl_data_submitted",
      "77123": "awaiting_parcel_handover_to_dhl_shipment_data_received",
      "77206": "shipment_picked_up",
      "77015": "processed_at_facility",
      "77027": "sorted_to_delivery_facility",
      "77169": "departed_from_facility",
      "77178": "arrived_at_facility",
      "77184": "processed_at_delivery_facility",
      "77090": "out_for_delivery",
      "77093": "successfully_delivered",
    }

    def status_slug
      STATUS_CODES[status]
    end
  end
end