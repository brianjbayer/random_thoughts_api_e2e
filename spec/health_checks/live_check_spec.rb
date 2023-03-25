# frozen_string_literal: true

require 'spec_helper'

RSpec.describe '/livez' do
  subject(:livez_request) { random_thoughts_unauth_connection.get(endpoint_url('/livez')) }

  it { expect(livez_request).to be_request_response(200, livez_response) }

  private

  def livez_response
    {
      'status' => 200,
      'message' => 'alive'
    }
  end
end
