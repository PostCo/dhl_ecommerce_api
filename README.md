# DHLEcommerceAPI

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/dhl_ecommerce_api`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'dhl_ecommerce_api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install dhl_ecommerce_api

# Configuration
In `config/initializers` create a `dhl_ecommerce_api.rb` config file
```ruby
DHLEcommerceAPI.configure do |config|
  config.client_id = ENV["DHL_ECOMMERCE_API_CLIENT_ID"]
  config.password = ENV["DHL_ECOMMERCE_API_PASSWORD"]
  config.pickup_account_id = ENV["DHL_ECOMMERCE_API_PICKUP_ACCOUNT_ID"]
  config.sold_to_account_id = ENV["DHL_ECOMMERCE_API_SOLD_TO_ACCOUNT_ID"]

  # optional, will refer to Rails.env
  # config.env = ENV["DHL_ECOMMERCE_API_ENV"]
end
```
# Usage
## Create Shipment with Pickup
[DHL Shipment Documentation](https://sandbox.dhlecommerce.asia/API/docs/v2/pickup.html)
```ruby
# Shipment::Pickup params
{
  "pickup_date_time": DateTime.now.to_s,
  "pickup_address": {
    "company_name": "Pickup From Company",
    "name": "Pickup From Name",
    "address1": "Holistic Pharmacy PostCo, 55, Jalan Landak",
    "city": " Kuala Lumpur",
    "state": " Kuala Lumpur",
    "post_code": "55100",
    "country": "MY",
    "phone": "0123456789",
    "email": "hello@example.com"
  },
  "shipment_items": [
    {
      "shipment_id": "MYPTC00001", # unique
      "package_desc": "Laptop Sleeve", 
      "total_weight": 500,
      "total_weight_uom": "G",
      "dimension_uom": "CM",
      "product_code": "PDO",
      "total_value": 300,
      "currency": "MYR",
      "is_routing_info_required": "Y",
      "consignee_address": {
        "company_name": "Sleeve Company",
        "name": "Sleeve Sdn Bhd",
        "address1": "No. 3, Jalan Bangsar, Kampung Haji Abdullah Hukum",
        "city": "Kuala Lumpur",
        "state": "Kuala Lumpur",
        "country": "MY",
        "postCode": "57000",
        "phone": "0123456789"
      }
    },
  ]
}
```

```ruby
DHLEcommerceAPI::Shipment::Pickup.create(params)
```


## Create Shipment w/o Pickup
Create a Shipment in DHLs system only. Used when we want to create a Shipment but not book a pickup. I.e. Generate the Shipment label for customers to print. (Use in conjunction with Pickup API.)
```ruby
# Shipment::Dropoff params
{
  "shipment_items" => [
    { 
      "shipment_id" => "MYPTC00002", # unique
      "package_desc" => "Bread Materials",
      "total_weight" => 2000,
      "total_weight_uom" => "G",
      "dimension_uom" => "CM",
      "product_code" => "PDO",
      "total_value" => 300,
      "currency" => "MYR",
      "is_routing_info_required" => "Y",
      "consignee_address" => { 
        "company_name" => "Test",
        "name" => "Test1",
        "address1" => "NO 3 JALAN PPU 1",
        "address2" => "TAMAN PERINDUSTRIAN PUCHONG UTAMA",
        "city" => "PUCHONG",
        "state" => "SELANGOR",
        "country" => "MY",
        "post_code" => "57000",
        "phone" => "0123456798"
      }
    }
  ]
}
```

```ruby
DHLEcommerceAPI::Shipment::Dropoff.create(params)
```

## Create Pickup
DHL will send a courier to pickup parcels from the `shipper_details` address. The courier will only pickup parcels with a valid DHL label.

[DHL Pickup Documentation](https://sandbox.dhlecommerce.asia/API/docs/v2/pickup.html)

```ruby
# Pickup params
{
  "handover_items": [
    {
      "pickup_date": "2022-03-09",
      "pickup_start_time": "09:00",
      "pickup_end_time": "18:00",
      "shipment_type": "1",
      "shipper_details": {
        "company": "PostCo",
        "name": "PostCo",
        "phone_number": "0123456789",
        "address_line_1": "No 31, Jalan 123/123",
        "city": "Petaling Jaya",
        "state": "Selangor",
        "postal_code": "57000",
        "country": "MY",
      },
      "shipments": {
        "quantity": 1,
        "totalWeight": 100
      }
    }
  ]
}
```
```ruby
DHLEcommerceAPI::Pickup.create(params)
```
## Tracking
[DHL Tracking Documentation](https://sandbox.dhlecommerce.asia/API/docs/v2/pickup.html)
```ruby
DHLEcommerceAPI::Tracking.find('MYPOS0001') 
# => [ShipmentItem]
```

```ruby
DHLEcommerceAPI::Tracking.find(['MYPOS0001', 'MYPOS0002']) 
# => [...ShipmentItems]
```


___


## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dhl_ecommerce_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/dhl_ecommerce_api/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DHLEcommerceAPI project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dhl_ecommerce_api/blob/master/CODE_OF_CONDUCT.md).
