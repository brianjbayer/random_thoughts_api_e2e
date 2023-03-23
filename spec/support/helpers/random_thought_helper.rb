# frozen_string_literal: true

require_relative 'hash_helper'

module RandomThoughtHelper
  class RandomThought
    include HashHelper

    attr_reader :thought, :mood

    def initialize
      @thought = Faker::Lorem.unique.sentence
      @mood = Faker::Lorem.unique.sentence
    end

    def to_request_body
      { random_thought: to_hash }
    end
  end

  def random_thoughts_endpoint
    '/v1/random_thoughts'
  end

  def build_random_thought
    RandomThought.new
  end

  def create_random_thought_request(random_thought, jwt)
    random_thoughts_auth_connection(jwt).post(random_thoughts_endpoint) do |req|
      req.body = random_thought.to_request_body
    end
  end

  def list_random_thoughts_request
    random_thoughts_unauth_connection.get(random_thoughts_endpoint)
  end
end
