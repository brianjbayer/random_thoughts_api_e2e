# frozen_string_literal: true

module EndpointHelper
  def endpoint_url(path)
    "#{base_url}#{path}"
  end

  def base_url
    ENV.fetch('E2E_BASE_URL')
  end
end

RSpec.configure do |config|
  config.include EndpointHelper
  config.include EndpointHelper
end
