# frozen_string_literal: true

require_relative "lib/dhl_ecommerce_api/version"

Gem::Specification.new do |spec|
  spec.name = "dhl_ecommerce_api"
  spec.version = DHLEcommerceAPI::VERSION
  spec.authors = ["Er Whey"]
  spec.email = ["erwhey@postco.co"]

  spec.summary = "Unofficial Ruby object based DHL eCommerce API wrapper."
  spec.description = "Unofficial Ruby object based DHL eCommerce API wrapper."
  spec.homepage = "https://github.com/PostCo/dhl_ecommerce_api"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/PostCo/dhl_ecommerce_api"
  spec.metadata["changelog_uri"] = "https://github.com/PostCo/dhl_ecommerce_api/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "activeresource", ">= 4.1.0", "< 6.0.0"
  
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "pry", "~> 0.14.1"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "gem-release"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
