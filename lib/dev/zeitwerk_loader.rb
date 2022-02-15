require "zeitwerk"
require_relative "config"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "dhl_ecommerce_api" => "DHLEcommerceAPI"
)
loader.push_dir("./lib")
loader.collapse("./lib/dhl_ecommerce_api/resources")
loader.ignore("#{__dir__}/config.rb")
loader.ignore("./lib/dhl_ecommerce_api/cache.rb")
loader.enable_reloading
# loader.log!
loader.setup

$__hermes_api_loader__ = loader

def reload!
  $__hermes_api_loader__.reload
  set_config
  true
end
