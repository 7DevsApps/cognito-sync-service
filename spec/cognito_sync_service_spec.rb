# frozen_string_literal: true

require 'cognito_attributes_converter.rb'
require 'cognito_pools_initializer.rb'
require 'cognito_provider.rb'

RSpec.describe CognitoSyncService do
  class UserExample
    extend ::CognitoSyncService
    include ::CognitoProvider
  end

  it 'has a version number' do
    expect(CognitoSyncService::VERSION).not_to be nil
  end

  context '#ca_create!' do
    context 'with valid phone_number in username' do
      let!(:username) { "+380958177784" }
      let!(:attrs ) { { phone_number: username }  }
      let(:user) { UserExample.ca_create!(attrs, username) }

      it { expect(user).to eq("") }
    end
  end
end
