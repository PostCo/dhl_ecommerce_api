# frozen_string_literal: true

RSpec.describe DHLEcommerceAPI::Shipment, type: :resource do

  describe "#destroy" do
    it "accepts a shipment id" do
      expect(subject.destroy("shipment_id")).to_not raise_error
      expect(subject.destroy).to raise_error
    end

    it "sends a request to DHL to destroy the Shipment" do
      expect(subject).to receive(:request).with(:delete, "/shipment/shipment_id")
      subject.destroy("shipment_id")
    end
  end
end
