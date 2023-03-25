# frozen_string_literal: true

# Custom RSpec Matcher to ensure
# paginated index response contains
# random thought

module IncludeRandomThought
  class IncludeRandomThought
    def initialize(status, random_thought_id, random_thought)
      @status = status
      @id = random_thought_id
      @random_thought = random_thought
    end

    def matches?(actual)
      @actual_status = actual.status
      @actual_body = actual.body

      found_random_thought = @actual_body['data']&.find { |item| item['id'] == @id }

      @actual_status == @status &&
        found_random_thought &&
        found_random_thought['thought'] == @random_thought.thought &&
        found_random_thought['mood'] == @random_thought.mood
    end

    def failure_message
      "expected that actual status code [#{@actual_status}] would match " \
        "expected status code [#{@status}] and that actual body " \
        "[#{pretty(@actual_body)}] would include a random_thought with " \
        "id [#{@id}], thought [#{@random_thought.thought}], and " \
        "mood [#{@random_thought.mood}]"
    end

    def failure_message_when_negated
      "expected that actual status code [#{@actual_status}] would not match " \
        "expected status code [#{@status}] and that actual body " \
        "[#{pretty(@actual_body)}] would not include a random_thought with " \
        "id [#{@id}], thought [#{@random_thought.thought}], and " \
        "mood [#{@random_thought.mood}]"
    end

    private

    def pretty(json)
      JSON.pretty_generate(json)
    end
  end

  def include_random_thought(status, random_thought_id, random_thought)
    IncludeRandomThought.new(status, random_thought_id, random_thought)
  end
end

# Include the custom matcher in RSpec
RSpec.configure do |config|
  config.include IncludeRandomThought
end
