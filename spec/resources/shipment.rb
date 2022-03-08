# frozen_string_literal: true

RSpec.describe DHLEcommerceAPI::Shipment, type: :resource do

  describe "#manifest_request" do
    let(:shipment) { DHLEcommerceAPI::Shipment.new(shipment_id: "123") }
    let(:headers) { { message_type: "SHIPMENT", access_token: "stubbed_token", message_version: "1.0", message_date_time: DateTime.now.to_s } }
    let(:expected_manifest_request) do
      {
        manifest_request: {
          hdr: headers,
          bd: {
            shipment_id: "123",
            pickup_account_id: nil,
            sold_to_account_id: nil,
          }
        }
      }
    end

    it "returns a manifest_request hash" do
      expect(shipment.manifest_request).to eq(expected_manifest_request)
    end
  end
end
