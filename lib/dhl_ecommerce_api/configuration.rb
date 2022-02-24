module DHLEcommerceAPI
  class Configuration
    attr_accessor :client_id, :password, :env
  end

  PRODUCTION_SITE = "#"
  PRE_PRODUCTION_SITE = "#"
  SANDBOX_SITE = "https://sandbox.dhlecommerce.asia"

  class << self
    def config
      @config ||= Configuration.new
    end

    def after_configure
      DHLEcommerceAPI::Base.site = get_url(config.env.to_s)
      
      if defined?(Rails) && Rails.respond_to?(:cache) && Rails.cache.is_a?(ActiveSupport::Cache::Store)
        DHLEcommerceAPI.cache = Rails.cache
      end
    end

    def get_url(env)
      case env
      when "production"
        PRODUCTION_SITE
      when "sandbox"
        SANDBOX_SITE
      when "preproduction"
        PRE_PRODUCTION_SITE
      end
    end

    def configure
      yield config

      after_configure
    end
  end
end
