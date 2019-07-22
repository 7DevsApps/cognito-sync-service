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
      let!(:username) { "+3333333334" }
      let!(:attrs ) { { phone_number: username } }
      let(:user) do
        UserExample.ca_delete!(username)
        UserExample.ca_create!(attrs, username)
      end

      it { expect(convert_from_cognito(user)).to eq(OpenStruct.new(phone_number: "+3333333334")) }
    end
  end
end
