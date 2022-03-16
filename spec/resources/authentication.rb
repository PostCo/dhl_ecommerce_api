# frozen_string_literal: true

RSpec.describe DHLEcommerceAPI::Authentication, type: :resource do
  before do
    DHLEcommerceAPI.cache.clear
  end

  describe "#get_token" do    
    context "cache is present" do
      it "returns the cached token" do
        DHLEcommerceAPI.cache.write("DHLEcommerceAPI::AuthenticationToken", "testtoken")
        expect(DHLEcommerceAPI::Authentication.get_token).to eq("testtoken")
      end
    end

    context "cache is not present" do
      before do
        stubbed_response = {
          "accessTokenResponse": {
            "token": "stubbed_token"
          }
        }
        stub_request(:get, /sandbox.dhlecommerce.asia/).
        with(
          headers: {
          'Accept'=>'application/json',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
          }).
        to_return(status: 200, body: stubbed_response.to_json, headers: {})
      end
      it "returns the token" do
        expect(DHLEcommerceAPI::Authentication.get_token).to eq("stubbed_token")
      end
    end
  end
end
