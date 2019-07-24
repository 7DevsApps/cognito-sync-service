# frozen_string_literal: true

require 'cognito_attributes_converter.rb'
require 'cognito_pools_initializer.rb'
require 'cognito_sync_service.rb'
require 'cognito_provider.rb'

RSpec.describe CognitoSyncService do
  class UserExample
    extend ::CognitoSyncService
    include ::CognitoAttributesConverter
    include ::CognitoProvider
    include ::CognitoPoolsInitializer
  end

  it 'has a version number' do
    expect(CognitoSyncService::VERSION).not_to be nil
  end

  context '#ca_create!' do
    context 'with valid phone_number in username' do
      let!(:username) { "+3333333333" }
      let!(:attrs) { { phone_number: username } }
      let(:user) { UserExample.ca_create!(attrs, username) }

      it { expect(convert_from_cognito(user)).to eq(OpenStruct.new(phone_number: "+3333333333")) }

      after { UserExample.ca_delete!(username) }
    end
  end

  context '#ca_delete!' do
    context 'by phone_number as username' do
      before { UserExample.ca_create!(attrs, username) }

      let!(:username) { "+3333333333" }
      let!(:attrs) { { phone_number: username } }

      it { expect(UserExample.ca_delete!(username).to_h).to eq({}) }
    end
  end

  context '#ca_find!' do
    context 'by phone_number as username' do
      before { UserExample.ca_create!(attrs, username) }

      let!(:username) { "+3333333333" }
      let!(:attrs) { { phone_number: username } }
      let!(:user) { UserExample.ca_find!(username) }

      it { expect(user.keys).to eq(%w[username user_create_date user_last_modified_date enabled user_status phone_number]) }

      after { UserExample.ca_delete!(username) }
    end

    context 'by email as username' do
      before { UserExample.ca_create!(attrs, username) }

      let!(:username) { "qwe@qwe.com" }
      let!(:attrs) { { email: username } }
      let!(:user) { UserExample.ca_find!(username) }

      it { expect(user.keys).to eq(%w[username user_create_date user_last_modified_date enabled user_status email]) }

      after { UserExample.ca_delete!(username) }
    end
  end
end
