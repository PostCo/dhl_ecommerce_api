module DHLEcommerceAPI
  class ShipmentCreation::ShipmentItem < Base
    def initialize(attributes = {}, persisted = false)
      status = attributes["response_status"]
      if status.present? && status["code"] == "200"
          error_messages = status["message_details"].map{|err| err["message_detail"]}
          handle_errors(status["code"], error_messages) 
        end
      end
      super
    end
  end
end