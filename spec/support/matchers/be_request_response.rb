# frozen_string_literal: true

# Custom RSpec Matcher to match an
# expected request response
module BeRequestResponse
  class BeRequestResponse
    def initialize(status, body)
      @status = status
      @body = body
    end

    def matches?(actual)
      @actual_status = actual.status
      @actual_body = actual.body

      @actual_status == @status &&
        @actual_body == @body
    end

    def failure_message
      "expected that actual status code [#{@actual_status}] would match " \
        "expected status code [#{@status}] and that actual body " \
        "[#{pretty(@actual_body)}] would match expected body " \
        "[#{pretty(@body)}]"
    end

    def failure_message_when_negated
      "expected that actual status code [#{@actual_status}] would not match " \
        "expected status code [#{@status}] and that actual body " \
        "[#{pretty(@actual_body)}] would match expected body " \
        "[#{pretty(@body)}]"
    end

    def description
      "have response status code [#{@status}] and body [#{@body}]"
    end

    private

    def pretty(json)
      JSON.pretty_generate(json)
    end
  end

  def be_request_response(status, body)
    BeRequestResponse.new(status, body)
  end
end

# Include the custom matcher in RSpec
RSpec.configure do |config|
  config.include BeRequestResponse
end
