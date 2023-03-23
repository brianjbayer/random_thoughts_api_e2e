# frozen_string_literal: true

module EndpointHelper
  def endpoint_url(path)
    "#{random_thoughts_base_url}#{path}"
  end

  def random_thoughts_base_url
    ENV.fetch('E2E_BASE_URL')
  end

  def random_thoughts_unauth_connection
    Faraday.new(url: random_thoughts_base_url) do |conn|
      conn.request :json
      conn.response :json
    end
  end

  def random_thoughts_auth_connection(jwt)
    Faraday.new(url: random_thoughts_base_url) do |conn|
      conn.request :json
      conn.request :authorization, 'Bearer', jwt
      conn.response :json
    end
  end
end

RSpec.configure do |config|
  config.include EndpointHelper
  config.include EndpointHelper
end
