# frozen_string_literal: true

require 'spec_helper'

require_relative '../support/helpers/auth_helper'
require_relative '../support/helpers/random_thought_helper'
require_relative '../support/helpers/user_helper'

# Disabling following Cops because...
#   1. Instance variables are needed in order to ensure created user is deleted
#      in the after block which is run even if test fails
#   2. Using the private methods which have the exceptions helps make the test
#      intent more understandable

# rubocop:disable RSpec/InstanceVariable, RSpec/NoExpectationExample
RSpec.describe 'New User Creates Random Thought' do
  include AuthHelper
  include RandomThoughtHelper
  include UserHelper

  let(:new_user) { build_random_thoughts_user }
  let(:new_random_thought) { build_random_thought }

  after do
    delete_user_request(@user_id, @user_jwt) if @user_id.is_a?(Integer) && @user_jwt
  end

  it 'Can create user, log in, and create random thought' do |example|
    can_create_new_user(example.reporter)
    new_user_can_log_in(example.reporter)
    new_user_can_create_random_thought(example.reporter)
    can_list_new_random_thought(example.reporter)
  end

  private

  # --- "Steps" ---
  def can_create_new_user(reporter)
    reporter.message('Can create new user...')
    create_new_user_response = create_user_request(new_user)

    # Need an id value for response matcher
    @user_id = create_new_user_response.body['id'] || 'IGNORE WHEN FAILS'
    expect(create_new_user_response).to be_request_response(201, created_user_response(@user_id, new_user))
    reporter.message('...New user created')
  end

  def new_user_can_log_in(reporter)
    reporter.message('New user can log in...')
    log_in_user_response = login_user_request(new_user)

    # Need a token value for response matcher
    jwt = log_in_user_response.body['token'] || 'IGNORE WHEN FAILS'
    expect(log_in_user_response).to be_request_response(200, logged_in_response(jwt))
    reporter.message('...New user is logged in')
    # If success set this for creating random thought and deleting user in after block
    @user_jwt = jwt
  end

  def new_user_can_create_random_thought(reporter)
    reporter.message('New user can create random thought...')
    create_new_random_thought_response = create_random_thought_request(new_random_thought, @user_jwt)

    # Need an id value for response matcher
    @random_thought_id = create_new_random_thought_response.body['id'] || 'IGNORE WHEN FAILS'
    created_random_thought = created_random_thought_response(@random_thought_id, new_random_thought, new_user)
    expect(create_new_random_thought_response).to be_request_response(201, created_random_thought)
    reporter.message('...Random thought is created')
  end

  def can_list_new_random_thought(reporter)
    # ASSUMPTION: Random Thoughts Are Ordered By Most Recent First
    reporter.message('Can list random thought...')
    listing_random_thoughts = list_random_thoughts_request

    expect(listing_random_thoughts).to include_random_thought(200, @random_thought_id, new_random_thought)
    reporter.message('...Random thought found in listing')
  end

  # --- Expected Responses ---
  def created_user_response(id, user)
    {
      'id' => id,
      'email' => user.email,
      'display_name' => user.display_name
    }
  end

  def logged_in_response(jwt)
    {
      'token' => jwt,
      'message' => 'User logged in successfully'
    }
  end

  def created_random_thought_response(id, random_thought, user)
    {
      'id' => id,
      'thought' => random_thought.thought,
      'mood' => random_thought.mood,
      'name' => user.display_name
    }
  end
end
# rubocop:enable RSpec/InstanceVariable, RSpec/NoExpectationExample
