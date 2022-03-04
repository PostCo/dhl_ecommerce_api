module DHLEcommerceAPI
  class Configuration
    attr_accessor :client_id, :password, :env, :pickup_account_id, :sold_to_account_id, :env
  end

  PRODUCTION_SITE = "#"
  PRE_PRODUCTION_SITE = "https://apitest.dhlecommerce.asia"
  SANDBOX_SITE = "https://sandbox.dhlecommerce.asia"

  class << self
    def config
      @config ||= Configuration.new
    end

    def after_configure
      site = get_url(config.env)

      if defined?(Rails) && 
        # set cache
        if Rails.respond_to?(:cache) && Rails.cache.is_a?(ActiveSupport::Cache::Store)
          DHLEcommerceAPI.cache = Rails.cache
        end
        # set env if defined
        if Rails.respond_to?(:env)
          site = get_url(Rails.env)
        end
      end
      
      DHLEcommerceAPI::Base.site = site
      DHLEcommerceAPI::Authentication.site = site
    end

    def get_url(env)
      case env
      when "production"
        PRODUCTION_SITE
      when "staging"
        PRE_PRODUCTION_SITE
      when "preproduction"
        PRE_PRODUCTION_SITE
      else
        SANDBOX_SITE
      end
    end

    def configure
      yield config
      after_configure
    end
  end
end
