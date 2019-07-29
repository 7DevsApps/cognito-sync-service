# frozen_string_literal: true

require 'cognito_attributes_converter.rb'
require 'cognito_pools_initializer.rb'
require 'cognito_sync_service.rb'
require 'cognito_provider.rb'

RSpec.describe CognitoSyncService do
  before do
    allow(UserExample).to receive(:cognito_provider).and_return(aws_provider)
    allow(UserExample).to receive(:web_pool_id).and_return(pool_id)
    allow(UserExample).to receive(:web_client_id).and_return(client_id)
  end

  class UserExample
    extend ::CognitoSyncService
    include ::CognitoAttributesConverter
    include ::CognitoProvider
    include ::CognitoPoolsInitializer
  end

  it 'has a version number' do
    expect(CognitoSyncService::VERSION).not_to be nil
  end

  describe '#ca_create!' do
    context 'with valid phone_number in username' do
      let!(:phone_number) { "+3333333333" }
      let!(:attrs) { { phone_number: phone_number } }
      let(:user) { UserExample.ca_create!(attrs, phone_number) }

      it { expect(user.keys).to match_array(%w[enabled user_create_date user_last_modified_date user_status username phone_number]) }
      it { expect(user['phone_number']).to eq(phone_number) }

      after { UserExample.ca_delete!(phone_number) }
    end
  end

  describe '#ca_delete!' do
    context 'by phone_number as username' do
      before { UserExample.ca_create!(attrs, phone_number) }

      let!(:phone_number) { "+3333333333" }
      let!(:attrs) { { phone_number: phone_number } }

      it { expect(UserExample.ca_delete!(phone_number).to_h).to eq({}) }
    end
  end

  describe '#ca_find!' do
    context 'by phone_number as username' do
      before { UserExample.ca_create!(attrs, phone_number) }

      let!(:phone_number) { "+3333333333" }
      let!(:attrs) { { phone_number: phone_number } }
      let!(:user_keys) { UserExample.ca_find!(phone_number).keys }

      it { expect(user_keys).to eq(%w[username user_create_date user_last_modified_date enabled user_status phone_number]) }

      after { UserExample.ca_delete!(phone_number) }
    end
    context 'by email as username' do
      before { UserExample.ca_create!(attrs, email) }

      let!(:email) { "qwe@qwe.com" }
      let!(:attrs) { { email: email } }
      let!(:user_keys) { UserExample.ca_find!(email).keys }

      it { expect(user_keys).to eq(%w[username user_create_date user_last_modified_date enabled user_status email]) }

      after { UserExample.ca_delete!(email) }
    end
  end

  describe '#ca_disable!' do
    context 'by phone_number as username' do
      let!(:phone_number) { "+3333333333" }
      let!(:attrs) { { phone_number: phone_number } }
      let!(:user) { UserExample.ca_create!(attrs, phone_number) }

      it do
        expect(user['enabled']).to eq(true)
        UserExample.ca_disable!(phone_number)
        expect(UserExample.ca_find!(phone_number)['enabled']).to eq(false)
      end

      after { UserExample.ca_delete!(phone_number) }
    end
  end

  describe '#ca_update!' do
    let(:phone_number) { "+111111111" }
    let!(:user) { UserExample.ca_create!({ email: "example1@gmail.com", phone_number: phone_number }, phone_number) }
    let!(:new_attrs) { { email: "example2@gmail.com" } }

    it 'should be change email attribute' do
      UserExample.ca_find!(phone_number)
      expect(user['email']).to eq("example1@gmail.com")
      expect(UserExample.ca_update!(new_attrs, phone_number)['email']).to eq("example2@gmail.com")
    end

    after { UserExample.ca_delete!(phone_number) }
  end
end
