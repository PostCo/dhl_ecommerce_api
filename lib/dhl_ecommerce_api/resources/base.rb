module DHLEcommerceAPI
  class Base < ActiveResource::Base
    self.include_format_in_path = false
    self.connection_class = Connection
  end
end