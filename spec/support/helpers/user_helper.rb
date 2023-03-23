# frozen_string_literal: true

require_relative 'hash_helper'

module UserHelper
  class RandomThoughtsUser
    include HashHelper

    attr_reader :email, :display_name, :password

    def initialize
      @email = "TTTEST_#{Faker::Internet.unique.email}"
      @display_name = "TTTEST_#{Faker::Name.unique.name}"
      @password = Faker::Internet.unique.password
      @password_confirmation = @password
    end

    def to_request_body
      { user: to_hash }
    end
  end

  def users_endpoint
    '/v1/users'
  end

  def users_id_endpoint(id)
    "#{users_endpoint}/#{id}"
  end

  def build_random_thoughts_user
    RandomThoughtsUser.new
  end

  def create_user_request(user)
    random_thoughts_unauth_connection.post(users_endpoint) do |req|
      req.body = user.to_request_body
    end
  end

  def delete_user_request(id, jwt)
    random_thoughts_auth_connection(jwt).delete(users_id_endpoint(id))
  end
end
