# frozen_string_literal: true

require 'spec_helper'

class LivezResponse
  def self.body_json
    '{ "status": 200, "message": "alive" }'
  end
end

RSpec.describe '/livez' do
  subject(:livez_request) { Faraday.get(endpoint_url('/livez')) }

  it 'returns status code 200' do
    expect(livez_request.status).to be(200)
  end

  it "returns expected JSON [#{LivezResponse.body_json}]" do
    expect(livez_request.body).to eql(LivezResponse.body_json)
  end
end
