# frozen_string_literal: true

require 'spec_helper'

RSpec.describe '/readyz' do
  subject(:readyz_request) { random_thoughts_unauth_connection.get(endpoint_url('/readyz')) }

  it { expect(readyz_request).to be_request_response(200, readyz_response) }

  private

  def readyz_response
    {
      'status' => 200,
      'message' => 'ready',
      'database_connection' => 'ok'
    }
  end
end
