module DHLEcommerceAPI
  class Configuration
    attr_accessor :client_id, :password, :env
  end

  PRODUCTION_SITE = "#"
  SANDBOX_SITE = "https://sandbox.dhlecommerce.asia"

  class << self
    def config
      @config ||= Configuration.new
    end

    def after_configure
      
      if defined?(Rails) && Rails.respond_to?(:cache) && Rails.cache.is_a?(ActiveSupport::Cache::Store)
        DHLEcommerceAPI.cache = Rails.cache
      end
    end

    def configure
      yield config

      after_configure
    end
  end
end
