module DHLEcommerceAPI
  class Pickup::HandoverItem < Base
    def initialize(attributes = {}, persisted = false)
      if attributes["response_status"].present?
        handle_errors(attributes)
      end
      super
    end

    def handle_errors(attributes)
      status = attributes["response_status"]
      code = status["code"]
      if code != "200"
        error_messages = status["message_details"].map{|err| err["message_detail"]}
        errors.add(:base, "#{code} - #{error_messages.join(", ")}") unless error_messages.empty? 
      end
    end
  end
end