# frozen_string_literal: true

require 'spec_helper'

require_relative '../support/helpers/auth_helper'
require_relative '../support/helpers/random_thought_helper'
require_relative '../support/helpers/user_helper'

# rubocop:disable RSpec/InstanceVariable, RSpec/NoExpectationExample, Metrics/AbcSize
# Disabling above Cops because...
#   1. Instance variables are needed in order to ensure created user is deleted
#      in the after block which is run even if test fails
#   2. Using the private methods which have the exceptions helps make the test
#      more understandable
#   3. All necessary steps and assertions are kept grouped together in the
#      private methods
RSpec.describe 'New User Creates Random Thought' do
  include AuthHelper
  include RandomThoughtHelper
  include UserHelper

  let(:new_user) { build_random_thoughts_user }
  let(:new_random_thought) { build_random_thought }

  after do
    delete_user_request(@user_id, @user_jwt)
  end

  it 'Can create user, log in, and create random thought' do |example|
    new_user_creates_account(example.reporter)
    new_user_logs_in(example.reporter)
    new_user_creates_random_thought(example.reporter)
    new_random_thought_is_listed(example.reporter)
  end

  private

  def new_user_creates_account(reporter)
    reporter.message('Create new user...')
    creating_new_user = create_user_request(new_user)
    expect(creating_new_user.status).to be(201)
    reporter.message('...New user created')
    @user_id = creating_new_user.body['id']
    expect(@user_id).to be_truthy
    expect(creating_new_user.body['email']).to eql(new_user.email)
    expect(creating_new_user.body['display_name']).to eql(new_user.display_name)
  end

  def new_user_logs_in(reporter)
    reporter.message('Log in new user...')
    logging_in_new_user = login_user_request(new_user)

    expect(logging_in_new_user.status).to be(200)
    reporter.message('...New user logged in')
    @user_jwt = logging_in_new_user.body['token']
    expect(@user_jwt).to be_truthy
    expect(logging_in_new_user.body['message']).to include('success')
  end

  def new_user_creates_random_thought(reporter)
    reporter.message('New user creates random thought...')
    creating_new_random_thought = create_random_thought_request(new_random_thought, @user_jwt)

    expect(creating_new_random_thought.status).to be(201)
    reporter.message('...Random thought created')
    @random_thought_id = creating_new_random_thought.body['id']
    expect(@random_thought_id).to be_truthy
    expect(creating_new_random_thought.body['thought']).to eql(new_random_thought.thought)
    expect(creating_new_random_thought.body['mood']).to eql(new_random_thought.mood)
  end

  def new_random_thought_is_listed(reporter)
    # ASSUMPTION: Random Thoughts Are Ordered By Most Recent First
    reporter.message('List newest random thoughts...')
    listing_random_thoughts = list_random_thoughts_request

    expect(listing_random_thoughts.status).to be(200)
    reporter.message('...Newest random thoughts listed')
    users_random_thought = listing_random_thoughts.body['data'].find { |item| item['id'] == @random_thought_id }
    expect(users_random_thought).not_to be_nil
    reporter.message("Found user's random thought in listing")
    expect(users_random_thought['thought']).to eql(new_random_thought.thought)
    expect(users_random_thought['mood']).to eql(new_random_thought.mood)
  end
end
# rubocop:enable RSpec/InstanceVariable, RSpec/NoExpectationExample, Metrics/AbcSize
