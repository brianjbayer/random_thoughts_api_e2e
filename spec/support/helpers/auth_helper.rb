# frozen_string_literal: true

module AuthHelper
  def login_endpoint
    '/v1/login'
  end

  def login_user_request(user)
    random_thoughts_unauth_connection.post(login_endpoint) do |req|
      req.body = login_body(user)
    end
  end

  private

  def login_body(user)
    body = user.to_hash.slice('email', 'password')
    { authentication: body }
  end
end
